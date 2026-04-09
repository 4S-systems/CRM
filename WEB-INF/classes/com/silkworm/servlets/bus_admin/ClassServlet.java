/*
 * ClassServlet.java
 *
 * Created on April 1, 2004, 8:08 AM
 */
package com.silkworm.servlets.bus_admin;

import java.io.*;

import javax.servlet.*;
import javax.servlet.http.*;

import com.silkworm.servlets.*;
import java.util.*;

import com.silkworm.common.bus_admin.*;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.Exceptions.*;

// this class is misplaced in this package, it will be moved later ISA
import com.docviewer.db_access.AccountItemMgr;

/**
 *
 * @author  walid
 * @version
 */
public class ClassServlet extends swBaseServlet {

    /** Initializes the servlet.
     */
    ClassMgr classMgr = ClassMgr.getInstance();
    AccountItemMgr accntItemMgr = AccountItemMgr.getInstance();
    WebBusinessObject wbo = new WebBusinessObject();
    Vector classList = null;
    boolean saveStatus = true;

    public void init(ServletConfig config) throws ServletException {
        super.init(config);

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

        operation = getOpCode(request.getParameter("op"));
        switch (operation) {
            case 1:



                servedPage = "/docs/bus_admin/new_class.jsp";


                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 2:
                scrapeForm(request);
                try {
                    saveStatus = classMgr.saveObject(wbo, session);

                    if (saveStatus) {
                        request.setAttribute("status", "ok");
                    } else {
                        request.setAttribute("status", "Error :Duplicate name");
                    }
                } catch (NoUserInSessionException noUser) {

                    ;
                }

                servedPage = "/docs/bus_admin/new_class.jsp";


                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 3:

                classMgr.cashData();

                classList = classMgr.getCashedTable();

                servedPage = "/docs/bus_admin/class_list.jsp";

                request.setAttribute("data", classList);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;


            case 4:

                String classId = request.getParameter("classId");


                servedPage = "/docs/bus_admin/confirm_delclass.jsp";

                request.setAttribute("classId", classId);

                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 5:

                String key = request.getParameter("classId");
                // delete from two tables

                accntItemMgr.deleteSecondRefIntegKey(key);
                classMgr.deleteOnSingleKey(key);

                classMgr.cashData();

                classList = classMgr.getCashedTable();

                servedPage = "/docs/bus_admin/class_list.jsp";

                request.setAttribute("data", classList);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 6:
                key = request.getParameter("classId");

                wbo = classMgr.getOnSingleKey(key);
                servedPage = "/docs/bus_admin/class_details.jsp";

                request.setAttribute("classItem", wbo);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);

                break;
            default:
                break;
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

    private void scrapeForm(HttpServletRequest request) {

        String desc = request.getParameter("classDescription");

        if (desc.equals("")) {
            desc = new String("none was provided");
        }
        wbo.setAttribute("classTitle", request.getParameter("classTitle"));
        wbo.setAttribute("classDescription", desc);
    }

    /** Returns a short description of the servlet.
     */
    public String getServletInfo() {
        return "General Classification Servlet";
    }

    public int getOpCode(String opName) {

        if (opName.equalsIgnoreCase("NewClass")) {
            return 1;
        }

        if (opName.equalsIgnoreCase("SaveClass")) {
            return 2;
        }

        if (opName.equalsIgnoreCase("ListAll")) {
            return 3;
        }
        if (opName.equalsIgnoreCase("ConfirmDelete")) {
            return 4;
        }
        if (opName.equalsIgnoreCase("Delete")) {
            return 5;
        }

        if (opName.equalsIgnoreCase("ViewDetails")) {
            return 6;
        }
        return 0;
    }
}
