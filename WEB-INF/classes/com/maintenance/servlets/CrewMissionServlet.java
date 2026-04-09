package com.maintenance.servlets;

import com.maintenance.db_access.CrewEmployeeMgr;
import com.maintenance.db_access.EmpBasicMgr;
import com.businessfw.hrs.db_access.EmployeeMgr;
import com.maintenance.db_access.StaffCodeMgr;
import com.maintenance.db_access.SupplierItemMgr;
import com.maintenance.db_access.CrewMissionMgr;
import com.silkworm.Exceptions.NoUserInSessionException;
import com.silkworm.business_objects.WebBusinessObject;
import com.tracker.servlets.TrackerBaseServlet;
import java.io.*;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Vector;

import javax.servlet.*;
import javax.servlet.http.*;

public class CrewMissionServlet extends TrackerBaseServlet {

    CrewMissionMgr crewMissionMgr;
    StaffCodeMgr staffCodeMgr = StaffCodeMgr.getInstance();
    EmpBasicMgr empBasicMgr = EmpBasicMgr.getInstance();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        super.processRequest(request, response);
        HttpSession session = request.getSession();

        switch (operation) {
            case 1:
                servedPage = "/docs/Adminstration/new_crew.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 2:
                servedPage = "/docs/Adminstration/new_crew.jsp";
                crewMissionMgr = CrewMissionMgr.getInstance();

                try {
                    if (!crewMissionMgr.getDoubleName(request.getParameter("crewName"))) {
                        if (crewMissionMgr.saveCrew(request, session)) {
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

                crewMissionMgr.cashData();
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 3:
                crewMissionMgr = CrewMissionMgr.getInstance();
                crewMissionMgr.cashData();
                Vector crew = crewMissionMgr.getCashedTable();
                servedPage = "/docs/Adminstration/crew_list.jsp";

                request.setAttribute("data", crew);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 4:
                servedPage = "/docs/Adminstration/view_crew.jsp";
                String crewID = request.getParameter("crewID");
                crewMissionMgr = CrewMissionMgr.getInstance();
                WebBusinessObject crewWBO = crewMissionMgr.getOnSingleKey(crewID);
                request.setAttribute("crewWBO", crewWBO);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 5:
                servedPage = "/docs/Adminstration/update_crew.jsp";
                crewID = request.getParameter("crewID");
                crewMissionMgr = CrewMissionMgr.getInstance();
                crewWBO = crewMissionMgr.getOnSingleKey(crewID);
                request.setAttribute("crewWBO", crewWBO);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 6:

                servedPage = "/docs/Adminstration/update_crew.jsp";
                crewID = request.getParameter("crewID");
                crewMissionMgr = CrewMissionMgr.getInstance();
                try {
                    if (!crewMissionMgr.getDoubleNameforUpdate(crewID, request.getParameter("crewName"))) {
                        if (crewMissionMgr.updateCrew(request)) {
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

                crewMissionMgr.cashData();
                crewWBO = crewMissionMgr.getOnSingleKey(crewID);
                request.setAttribute("crewWBO", crewWBO);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 7:
                servedPage = "/docs/Adminstration/crew_staff.jsp";
                crewID = request.getParameter("crewID");
                crewMissionMgr = CrewMissionMgr.getInstance();
                crewWBO = crewMissionMgr.getOnSingleKey(crewID);
                EmployeeMgr employeeMgr = EmployeeMgr.getInstance();
                employeeMgr.cashData();
                ArrayList employeeList = employeeMgr.getCashedTableAsBusObjects();
                empBasicMgr.cashData();
                ArrayList empbasicList = empBasicMgr.getCashedTableAsBusObjects();
                request.setAttribute("crewID", crewID);
                request.setAttribute("crewWBO", crewWBO);
                request.setAttribute("employeeList", employeeList);
                request.setAttribute("empbasicList", empbasicList);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 8:
                String staffcode = null;
//                String crewName = null;
//                String staffName=null;
//                String crewCode = null;
                servedPage = "/docs/Adminstration/crew_staff.jsp";
//                crewID = request.getParameter("crewID");
//                String staffId = request.getParameter("staffCode");
//                crewMissionMgr = CrewMissionMgr.getInstance();
//                WebBusinessObject staffWBO = staffCodeMgr.getOnSingleKey(staffId);
//                crewWBO = crewMissionMgr.getOnSingleKey(crewID);
//                crewName = crewWBO.getAttribute("crewName").toString();
//                staffName = staffWBO.getAttribute("code").toString();
//                crewCode = crewName+"-"+staffName;
                employeeMgr = EmployeeMgr.getInstance();
                employeeMgr.cashData();
                CrewEmployeeMgr crewEmployeeMgr = CrewEmployeeMgr.getInstance();
                String[] staff = request.getParameterValues("staff");
                if (request.getParameterValues("staff") != null) {

                    try {
                        if (staffCodeMgr.getSaveStaff(request.getParameter("staffCode"))) {
                            request.setAttribute("Status", "Double");
                        } else {
                            for (int i = 0; i < staff.length; i++) {
                                staffcode = staff[i];

                                if (crewEmployeeMgr.saveCrewEmployee(request, session, staffcode)) {
                                    crewEmployeeMgr.saveCrewFlag(request, session, staffcode);
                                    request.setAttribute("Status", "Ok");
                                } else {
                                    request.setAttribute("Status", "No");
                                }
                            }
                        }
                    } catch (NoUserInSessionException ex) {
                        logger.error(ex.getMessage());
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }

                }
                employeeList = employeeMgr.getCashedTableAsBusObjects();
                empbasicList = empBasicMgr.getCashedTableAsBusObjects();
//                request.setAttribute("crewWBO", crewWBO);
                request.setAttribute("employeeList", employeeList);
                request.setAttribute("empbasicList", empbasicList);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;


            case 9:

                servedPage = "/docs/Adminstration/crew_staff_update.jsp";
                String crewCodeName = request.getParameter("crewCodeName");
                String code = request.getParameter("staffCode");
//                String idCode= request.getParameter("idCode");
////                crewID = request.getParameter("crewID");
                crewEmployeeMgr = CrewEmployeeMgr.getInstance();

                Vector vecStaff = new Vector();
                try {
                    Vector tempStaff = crewEmployeeMgr.getOnArbitraryKey(code, "key1");
                    for (int i = 0; i < tempStaff.size(); i++) {
                        WebBusinessObject wbo = (WebBusinessObject) tempStaff.elementAt(i);
                        vecStaff.add(wbo.getAttribute("employeeID").toString());
                    }
                } catch (SQLException ex) {
                    logger.error(ex.getMessage());
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }
//                crewWBO = crewMissionMgr.getOnSingleKey(crewID);
                employeeMgr = EmployeeMgr.getInstance();
                employeeMgr.cashData();
                employeeList = employeeMgr.getCashedTableAsBusObjects();

                empBasicMgr.cashData();
                empbasicList = empBasicMgr.getCashedTableAsBusObjects();
//                request.setAttribute("crewID", crewID);


                request.setAttribute("staffCode", code);
                request.setAttribute("crewCodeName", crewCodeName);
                request.setAttribute("vecStaff", vecStaff);
                request.setAttribute("employeeList", employeeList);
                request.setAttribute("empbasicList", empbasicList);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 10:
                String staffsize = null;
                servedPage = "/docs/Adminstration/crew_staff_update.jsp";
                crewCodeName = request.getParameter("crewCodeName");
//                crewID = request.getParameter("crewID");
                code = request.getParameter("staffCode");
                 staffsize = request.getParameter("staffSize");
                crewMissionMgr = CrewMissionMgr.getInstance();
//                crewWBO = crewMissionMgr.getOnSingleKey(crewID);
//                staffWBO = staffCodeMgr.getOnSingleKey(idCode);
//                crewName = crewWBO.getAttribute("crewName").toString();
//                staffName = staffWBO.getAttribute("code").toString();
//                crewCode = crewName+"-"+staffName;
                employeeMgr = EmployeeMgr.getInstance();
                employeeMgr.cashData();
                crewEmployeeMgr = CrewEmployeeMgr.getInstance();
                vecStaff = new Vector();
                String[] staffId = request.getParameterValues("staff");

                try {
                    crewEmployeeMgr.deleteOnArbitraryKey(code, "key1");
                    if (staffsize.toString().equals("0")){
                        crewEmployeeMgr.UpdateStaffFlag(code);
                    }
                //crewEmployeeMgr.UpdateStaffFlag(code);
                } catch (SQLException ex) {
                    logger.error(ex.getMessage());
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }
                if (request.getParameterValues("staff") != null) {

                    try {
                        for (int i = 0; i < staffId.length; i++) {
                            staffcode = staffId[i];
                            if (crewEmployeeMgr.saveCrewEmployee(request, session, staffcode)) {
                                request.setAttribute("Status", "Ok");
                            } else {
                                request.setAttribute("Status", "No");
                            }
                        }
                    } catch (NoUserInSessionException ex) {
                        logger.error(ex.getMessage());
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }
                }
                employeeList = employeeMgr.getCashedTableAsBusObjects();

                empBasicMgr.cashData();
                empbasicList = empBasicMgr.getCashedTableAsBusObjects();

                request.setAttribute("vecStaff", vecStaff);
//                request.setAttribute("crewID", crewID);
//                request.setAttribute("idCode", idCode);

                request.setAttribute("staffCode", code);
                request.setAttribute("crewCodeName", crewCodeName);
                request.setAttribute("employeeList", employeeList);
                request.setAttribute("empbasicList", empbasicList);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 11:

                servedPage = "/docs/Adminstration/crew_staff_view.jsp";
                crewCodeName = request.getParameter("crewCodeName");
                code = request.getParameter("staffCode");
//                idCode= request.getParameter("idCode");
//                crewID = request.getParameter("crewID");
                crewEmployeeMgr = CrewEmployeeMgr.getInstance();
                vecStaff = new Vector();
                try {
                    vecStaff = crewEmployeeMgr.getOnArbitraryKey(code, "key1");

//                    for(int i = 0; i < vecStaff.size(); i++){
//                        WebBusinessObject wbo = (WebBusinessObject) vecStaff.elementAt(i);
//                        vecStaff.add(wbo.getAttribute("employeeID").toString());
//                        vecStaff.add(wbo.getAttribute("leader").toString());
//                    }
                } catch (SQLException ex) {
                    logger.error(ex.getMessage());
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }
//                crewWBO = crewMissionMgr.getOnSingleKey(crewID);
                employeeMgr = EmployeeMgr.getInstance();
                employeeMgr.cashData();
                employeeList = employeeMgr.getCashedTableAsBusObjects();

                empBasicMgr.cashData();
                empbasicList = empBasicMgr.getCashedTableAsBusObjects();

//                request.setAttribute("crewID", crewID);
                request.setAttribute("staffCode", code);
                request.setAttribute("crewCodeName", crewCodeName);
                request.setAttribute("vecStaff", vecStaff);
                request.setAttribute("employeeList", employeeList);
                request.setAttribute("empbasicList", empbasicList);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 12:
                String itemID = request.getParameter("itemID");
                String categoryId = request.getParameter("categoryId");
                crewID = request.getParameter("crewID");
                SupplierItemMgr supplierItemMgr = SupplierItemMgr.getInstance();

                try {
                    if (supplierItemMgr.updateSupplierItem(request)) {
                        request.setAttribute("Status", "Ok");
                    }
                } catch (NoUserInSessionException ex) {
                    request.setAttribute("Status", "No");
                }
                Vector vecSupplier = supplierItemMgr.getItemSupplier(itemID, crewID);
                WebBusinessObject supplierItem = new WebBusinessObject();
                if (vecSupplier.size() > 0) {
                    supplierItem = (WebBusinessObject) vecSupplier.elementAt(0);
                }
                servedPage = "/docs/Adminstration/update_item_supplier.jsp";
                request.setAttribute("supplierItem", supplierItem);
                request.setAttribute("itemID", itemID);
                request.setAttribute("categoryId", categoryId);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 13:
                itemID = request.getParameter("itemID");
                categoryId = request.getParameter("categoryId");
                crewID = request.getParameter("crewID");
                String supplierName = request.getParameter("supplierName");
                servedPage = "/docs/Adminstration/confirm_delSupplierItem.jsp";
                request.setAttribute("itemID", itemID);
                request.setAttribute("crewID", crewID);
                request.setAttribute("supplierName", supplierName);
                request.setAttribute("categoryId", categoryId);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 14:
                supplierItemMgr = SupplierItemMgr.getInstance();
                itemID = request.getParameter("itemID");
                categoryId = request.getParameter("categoryId");
                crewID = request.getParameter("crewID");
                try {
                    supplierItemMgr.deleteItemSupplier(itemID, crewID);
                    crew = supplierItemMgr.getOnArbitraryKey(itemID, "key");
                    request.setAttribute("data", crew);
                } catch (SQLException ex) {
                    logger.error(ex.getMessage());
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }
                servedPage = "/docs/Adminstration/item_supplier_list.jsp";
                request.setAttribute("itemID", itemID);
                request.setAttribute("crewID", crewID);
                request.setAttribute("categoryId", categoryId);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 15:
//                crewID = request.getParameter("crewID");
                Vector crewMission = new Vector();
                crewMissionMgr = CrewMissionMgr.getInstance();
                crewMissionMgr.cashData();
//                categoryMgr.cashData();
                crewMission = crewMissionMgr.getAllCrewMission();
                servedPage = "/docs/Adminstration/staff_By_Crew_List.jsp";

                request.setAttribute("data", crewMission);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 16:
                crewID = request.getParameter("crewID");
                Vector staffCode = new Vector();
                crewEmployeeMgr = CrewEmployeeMgr.getInstance();
//                crewMissionMgr = CrewMissionMgr.getInstance();
//                crewMissionMgr.cashData();
                staffCodeMgr.cashData();
                staffCode = staffCodeMgr.getCashedTable();
//                staffCode = crewEmployeeMgr.getStaffCode(crewID);
                servedPage = "/docs/Adminstration/staff_list.jsp";

//                request.setAttribute("crewID", crewID);
                request.setAttribute("data", staffCode);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);

                break;

            case 17:
//
                servedPage = "/docs/Adminstration/crew_refresh_staff.jsp";
                crewCodeName = request.getParameter("crewCodeName");
                code = request.getParameter("staffCode");
                crewID = request.getParameter("crewID");
                crewMissionMgr = CrewMissionMgr.getInstance();
                crewWBO = crewMissionMgr.getOnSingleKey(crewID);
                employeeMgr = EmployeeMgr.getInstance();
                employeeMgr.cashData();
                employeeList = employeeMgr.getCashedTableAsBusObjects();

                request.setAttribute("crewCodeName", crewCodeName);
                request.setAttribute("staffCode", code);
                request.setAttribute("employeeList", employeeList);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 18:
                servedPage = "/docs/Adminstration/confirm_del_crew.jsp";
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
        return "Equipment Servlet";
    }

    protected int getOpCode(String opName) {
        if (opName.indexOf("GetCrewForm") == 0) {
            return 1;
        }

        if (opName.indexOf("SaveCrew") == 0) {
            return 2;
        }

        if (opName.indexOf("ListCrew") == 0) {
            return 3;
        }

        if (opName.indexOf("ViewCrew") == 0) {
            return 4;
        }

        if (opName.indexOf("GetUpdateForm") == 0) {
            return 5;
        }

        if (opName.equalsIgnoreCase("UpdateCrew")) {
            return 6;
        }

        if (opName.equalsIgnoreCase("CreateStaff")) {
            return 7;
        }

        if (opName.equalsIgnoreCase("SaveStaff")) {
            return 8;
        }

        if (opName.equalsIgnoreCase("GetUpdateStaffForm")) {
            return 9;
        }

        if (opName.equalsIgnoreCase("UpdateStaff")) {
            return 10;
        }

        if (opName.indexOf("ViewStaff") == 0) {
            return 11;
        }

        if (opName.indexOf("UpdateItemSupplier") == 0) {
            return 12;
        }

        if (opName.indexOf("ConfirmItemSupplierDelete") == 0) {
            return 13;
        }

        if (opName.indexOf("DeleteItemSupplier") == 0) {
            return 14;
        }

        if (opName.indexOf("StaffByCrew") == 0) {
            return 15;
        }

        if (opName.indexOf("ShowStaff") == 0) {
            return 16;
        }

        if (opName.indexOf("GetRefreshUpdateStaffForm") == 0) {
            return 17;
        }

        if (opName.indexOf("ConfirmDelete") == 0) {
            return 18;
        }

        return 0;
    }
}
