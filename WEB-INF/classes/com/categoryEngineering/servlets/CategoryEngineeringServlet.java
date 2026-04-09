/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.categoryEngineering.servlets;

import com.tracker.servlets.TrackerBaseServlet;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author khaled abdo
 */
public class CategoryEngineeringServlet extends TrackerBaseServlet {

    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        super.processRequest(request, response);
      
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        //Get Session
        HttpSession session = request.getSession();

        operation = getOpCode((String) request.getParameter("op"));


        switch (operation) {
            case 1:
                servedPage = "/docs/categoryEngineering/insert_jsp_type_form.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            default:
                break;
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
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
     * Handles the HTTP <code>POST</code> method.
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
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

    @Override
    protected int getOpCode(String opName) {

        if (opName.equalsIgnoreCase("insertJspTypeForm")) {
            return 1;
        } else if (opName.equalsIgnoreCase("insertJspType")) {
            return 2;
        } else if (opName.equalsIgnoreCase("updateJspTypeForm")) {
            return 3;
        } else if (opName.equalsIgnoreCase("selectAllJspTypesName")) {
            return 4;
        } else if (opName.equalsIgnoreCase("selectJspType")) {
            return 5;
        }
        return 0;
    }
}
