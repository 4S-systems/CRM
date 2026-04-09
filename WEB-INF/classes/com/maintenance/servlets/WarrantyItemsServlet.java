package com.maintenance.servlets;

import com.maintenance.db_access.WarrantyItemsMgr;
import com.silkworm.business_objects.WebBusinessObject;
import java.io.*;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.*;
import javax.servlet.http.*;
import com.tracker.servlets.TrackerBaseServlet;
import java.util.Vector;
import javax.swing.JOptionPane;

public class WarrantyItemsServlet extends TrackerBaseServlet {

    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }

    public void destroy() {
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        super.processRequest(request, response);
        HttpSession session = request.getSession();
        WebBusinessObject user = (WebBusinessObject) session.getAttribute("loggedUser");
        switch (operation) {
            case 1:
                this.forward("/docs/issue/add_warranty.jsp", request, response);
                break;

            case 2:
                WarrantyItemsMgr warrantyItemsMgr = WarrantyItemsMgr.getInstance();
                WebBusinessObject wbo = new WebBusinessObject();
                String[] partId = request.getParameterValues("partId");
                String[] partCode = request.getParameterValues("partCode");
                String[] vendor = request.getParameterValues("vendor");
                String[] bDate = request.getParameterValues("bDate");
                String[] eDate = request.getParameterValues("eDate");
                String[] note = request.getParameterValues("note");
                for (int i = 0; i < partId.length; i++) {
                    wbo.setAttribute("partId", partId[i]);
                    wbo.setAttribute("partCode", partCode[i]);
                    wbo.setAttribute("vendor", vendor[i]);
                    wbo.setAttribute("bDate", bDate[i]);
                    wbo.setAttribute("eDate", eDate[i]);
                    wbo.setAttribute("note", note[i]);
                    wbo.setAttribute("userId", user.getAttribute("id"));
                    try {
                        warrantyItemsMgr.deleteOnArbitraryKey(partId[i], "key1");
                        warrantyItemsMgr.saveObject(wbo);
                    } catch (SQLException ex) {
                        Logger.getLogger(WarrantyItemsServlet.class.getName()).log(Level.SEVERE, null, ex);
                    } catch (Exception ex) {
                        Logger.getLogger(WarrantyItemsServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
                this.forward("IssueServlet?op=addPartsWarranty", request, response);
                break;

            case 3:
                warrantyItemsMgr = WarrantyItemsMgr.getInstance();
                wbo = new WebBusinessObject();
                wbo = warrantyItemsMgr.getOnSingleKey(request.getParameter("id"));
                request.setAttribute("oldWarranty", wbo);
                this.forward("/docs/issue/update_warranty.jsp", request, response);
                break;

            case 4:
                warrantyItemsMgr = WarrantyItemsMgr.getInstance();
                warrantyItemsMgr.deleteOnSingleKey(request.getParameter("id"));
                this.forward("IssueServlet?op=addPartsWarranty", request, response);
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
        return "Warranty Servlet";
    }

    protected int getOpCode(String opName) {
        if (opName.equalsIgnoreCase("GetForm")) {
            return 1;
        }
        if (opName.equalsIgnoreCase("saveForm")) {
            return 2;
        }
        if (opName.equalsIgnoreCase("updateForm")) {
            return 3;
        }
        if (opName.equalsIgnoreCase("delete")) {
            return 4;
        }
        return 0;
    }
}
