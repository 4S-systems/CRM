package com.planning.servlets;

import com.maintenance.common.DateParser;
import com.planning.db_access.PlanMgr;
import com.planning.db_access.SectorMgr;
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
import java.util.ArrayList;
import java.util.Vector;

public class SectorServlet extends swBaseServlet {

    SectorMgr sectorMgr = SectorMgr.getInstance();
    WebIssue wIssue = new WebIssue();
    WebBusinessObject sector = null;
    WebBusinessObject userObj = null;
    String viewOrigin = null;

    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        servedPage = "/docs/Adminstration/new_plan.jsp";
    }

    /**
     * Destroys the servlet.
     */
    public void destroy() {
    }

    /**
     * Processes requests for both HTTP
     * <code>GET</code> and
     * <code>POST</code> methods.
     *
     * @param request servlet request
     * @param response servlet response
     */
    @SuppressWarnings("empty-statement")
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        super.processRequest(request, response);
        HttpSession session = request.getSession();
        userObj = (WebBusinessObject) session.getAttribute("loggedUser");

        String page = null;

        operation = getOpCode((String) request.getParameter("op"));

        switch (operation) {

            case 1:
                servedPage = "/docs/planning/new_sector.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 2:
                sector = new WebBusinessObject();
                String planCode = request.getParameter("planCode");
                String planDesc = request.getParameter("planDesc");
                String arDesc = request.getParameter("arDesc");
                sector.setAttribute("planCode", planCode);
                sector.setAttribute("sectorName", arDesc);
                sector.setAttribute("planDesc", planDesc);


                sector.printSelf();
                try {
                    boolean rs = sectorMgr.saveObject(sector, session);
                    if (rs) {
                        request.setAttribute("status", "ok");
                    } else {
                        request.setAttribute("status", "faild");
                    }
                } catch (NoUserInSessionException ex) {
                    Logger.getLogger(SectorServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                servedPage = "/docs/planning/new_sector.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);

                break;

            case 3:
                System.out.println("ana hena");
                ArrayList mySectors = sectorMgr.getCashedTableAsArrayList();

                System.out.println("here");
                servedPage = "/docs/planning/sector_list.jsp";

//                Vector userList = userMgr.getAllRowByIndex();
//                long numberOfUsers = userMgr.countAll();
//                servedPage = "/docs/Adminstration/sector_list.jsp";
//
                request.setAttribute("data", mySectors);

                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 4:
                servedPage = "/docs/planning/view_sector.jsp";
                String id = request.getParameter("id");
                WebBusinessObject sector = new WebBusinessObject();

                sector = sectorMgr.getOnSingleKey(id);
                request.setAttribute("id", id);
                request.setAttribute("page", servedPage);
                request.setAttribute("sector", sector);
                this.forwardToServedPage(request, response);

                break;
            case 5:

                id = request.getParameter("id");
                sector = sectorMgr.getOnSingleKey(id);
                servedPage = "/docs/planning/update_sector.jsp";
                request.setAttribute("id", id);
                request.setAttribute("page", servedPage);
                request.setAttribute("sector", sector);
                this.forwardToServedPage(request, response);
                break;
            case 6:
                id = request.getParameter("id");
                sector = new WebBusinessObject();
                String sectorCode = request.getParameter("sectorCode");
                String ardesc = request.getParameter("SECTOR_AR_DESC");
                String enDesc = request.getParameter("SECTOR_EN_DES");
                sector.setAttribute("sectorCode", sectorCode);
                sector.setAttribute("sectorArDesc", ardesc);
                sector.setAttribute("sectorEnDesc", enDesc);
                sector.setAttribute("id", id);
                // servedPage = "/docs/planning/view_sector.jsp";



                try {
                    boolean rs = sectorMgr.updateSector(sector);
                    if (rs) {
                        request.setAttribute("status", "ok");
                        request.setAttribute("sector", sector);
                        servedPage = "/docs/planning/view_sector.jsp";
                    } else {
                        request.setAttribute("status", "faild");
                    }
                } catch (NoUserInSessionException ex) {
                    Logger.getLogger(SectorServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                servedPage = "/docs/planning/update_sector.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);

                break;
            case 7:
                id = request.getParameter("id");
                sector = sectorMgr.getOnSingleKey(id);
                ardesc = request.getParameter("SECTOR_AR_DESC");
                enDesc = request.getParameter("SECTOR_EN_DES");
                servedPage = "/docs/planning/confirm_delsector.jsp";

                request.setAttribute("sectorCode", (String) sector.getAttribute("sectorCode"));
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 8:

                id = request.getParameter("id");
                boolean rs = sectorMgr.deleteOnSingleKey(id);
                if (rs) {
                    servedPage = "SectorServlet?op=displaySectors";
                    request.setAttribute("page", servedPage);
                    this.forward(servedPage, request, response);
                }
                break;

            default:
                this.forwardToServedPage(request, response);

        }

    }

    /**
     * Handles the HTTP
     * <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     */
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
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     */
    public String getServletInfo() {
        return "Plan Servlet";
    }

    protected int getOpCode(String opName) {

        if (opName.equalsIgnoreCase("getNewSectorForm")) {
            return 1;
        }

        if (opName.equalsIgnoreCase("createSector")) {
            return 2;
        }
        if (opName.equalsIgnoreCase("displaySectors")) {
            return 3;
        }
        if (opName.equalsIgnoreCase("viewSector")) {
            return 4;
        }
        if (opName.equalsIgnoreCase("updateSector")) {
            return 5;
        }
        if (opName.equalsIgnoreCase("saveUpdate")) {
            return 6;
        }
        if (opName.equalsIgnoreCase("confirmDeletion")) {
            return 7;
        }
        if (opName.equalsIgnoreCase("Delete")) {
            return 8;
        }




        return 0;
    }
}
