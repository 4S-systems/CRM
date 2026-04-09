package com.maintenance.servlets;

import com.maintenance.db_access.EmpBasicMgr;
import com.maintenance.db_access.ProductionLineMgr;
import com.maintenance.db_access.StaffCodeMgr;
import com.maintenance.db_access.CrewMissionMgr;
import com.silkworm.Exceptions.NoUserInSessionException;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.common.SecurityUser;
import com.silkworm.logger.db_access.LoggerMgr;
import com.tracker.servlets.TrackerBaseServlet;
import java.io.*;
import java.sql.SQLException;
import java.util.Vector;

import javax.servlet.*;
import javax.servlet.http.*;

public class ProductionLineServlet extends TrackerBaseServlet {

    CrewMissionMgr crewMissionMgr;
    ProductionLineMgr productionLineMgr = ProductionLineMgr.getInstance();
    LoggerMgr loggerMgr = LoggerMgr.getInstance();
    StaffCodeMgr staffCodeMgr = StaffCodeMgr.getInstance();
    EmpBasicMgr empBasicMgr = EmpBasicMgr.getInstance();
    
    String productionLineId;
    String productionLineCode;

    SecurityUser securityUser;

    @Override
    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        super.processRequest(request, response);
        HttpSession session = request.getSession();
        securityUser = (SecurityUser) session.getAttribute("securityUser");

        switch (operation) {
            case 1:
                servedPage = "/docs/Adminstration/new_ProductionLine.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 2:
                servedPage = "/docs/Adminstration/new_ProductionLine.jsp";
                crewMissionMgr = CrewMissionMgr.getInstance();

                try {
                    if (!productionLineMgr.getDoubleName(request.getParameter("code"))) {
                        if (productionLineMgr.saveProduction(request, session)) {
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

                productionLineMgr.cashData();
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 3:
                productionLineMgr = ProductionLineMgr.getInstance();
                productionLineMgr.cashData();
                Vector production = productionLineMgr.getCashedTable();
                servedPage = "/docs/Adminstration/productionLine_list.jsp";

                request.setAttribute("data", production);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 4:
                servedPage = "/docs/Adminstration/view_productionLine.jsp";
                String productionId = request.getParameter("prodID");
                productionLineMgr = ProductionLineMgr.getInstance();
                WebBusinessObject productionLineWbo = productionLineMgr.getOnSingleKey(productionId);
                request.setAttribute("productionLineWbo", productionLineWbo);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 5:
                servedPage = "/docs/Adminstration/update_productionLine.jsp";
                productionId = request.getParameter("prodID");

                productionLineWbo = productionLineMgr.getOnSingleKey(productionId);
                request.setAttribute("productionLineWbo", productionLineWbo);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 6:

                servedPage = "/docs/Adminstration/update_productionLine.jsp";
                productionId = request.getParameter("id");

                try {
                    if (!productionLineMgr.getDoubleNameforUpdate(productionId, request.getParameter("code"))) {
                        if (productionLineMgr.updateProductionLine(request, session)) {
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

                productionLineMgr.cashData();
                productionLineWbo = productionLineMgr.getOnSingleKey(productionId);
                request.setAttribute("productionLineWbo", productionLineWbo);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;


            case 7:
                productionLineId = request.getParameter("productionLineId");
                productionLineCode = request.getParameter("code");

                servedPage = "/docs/Adminstration/confirm_delete_production_line.jsp";
                request.setAttribute("productionLineId", productionLineId);
                request.setAttribute("productionLineCode", productionLineCode);
                request.setAttribute("canDelete", productionLineMgr.canDelete(productionLineId));
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 8:
                WebBusinessObject loggerWbo = new WebBusinessObject();
                fillLoggerWbo(request, loggerWbo);
                if (productionLineMgr.deleteOnSingleKey(request.getParameter("productionLineId"))) {
                    try {
                        loggerMgr.saveObject(loggerWbo);
                    } catch (SQLException ex) {
                        logger.error(ex.getMessage());
                    }
                }
                this.forward("ProductionLineServlet?op=ListProductionLine", request, response);
                break;

            default:
                logger.info("No operation was matched");
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
        return "Equipment Servlet";
    }

    @Override
    protected int getOpCode(String opName) {
        if (opName.indexOf("GetProductionLineForm") == 0) {
            return 1;
        }

        if (opName.indexOf("SaveProduction") == 0) {
            return 2;
        }

        if (opName.indexOf("ListProductionLine") == 0) {
            return 3;
        }

        if (opName.indexOf("ViewproductionLine") == 0) {
            return 4;
        }

        if (opName.indexOf("GetUpdateForm") == 0) {
            return 5;
        }

        if (opName.equalsIgnoreCase("UpdateProductionLine")) {
            return 6;
        }


        if (opName.indexOf("ConfirmDelete") == 0) {
            return 7;
        }

        if (opName.indexOf("delete") == 0) {
            return 8;
        }

        return 0;
    }

    private void fillLoggerWbo(HttpServletRequest request, WebBusinessObject loggerWbo) {
        WebBusinessObject objectXml = productionLineMgr.getOnSingleKey(request.getParameter("productionLineId"));
        loggerWbo.setAttribute("objectXml", objectXml.getObjectAsXML());
        loggerWbo.setAttribute("realObjectId", request.getParameter("productionLineId"));
        loggerWbo.setAttribute("userId", securityUser.getUserId());
        loggerWbo.setAttribute("objectName", "Production Line");
        loggerWbo.setAttribute("loggerMessage", "Production Line Deleted");
        loggerWbo.setAttribute("eventName", "Delete");
        loggerWbo.setAttribute("objectTypeId", "8");
        loggerWbo.setAttribute("eventTypeId", "2");
    }
}
