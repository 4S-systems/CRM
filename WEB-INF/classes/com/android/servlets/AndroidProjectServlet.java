/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.android.servlets;

import com.maintenance.db_access.EmployeeViewMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.tracker.db_access.ProjectMgr;
import flexjson.JSONSerializer;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author MOSTAFA
 */
public class AndroidProjectServlet extends HttpServlet {

    ProjectMgr projectMgr = ProjectMgr.getInstance();
    JSONSerializer serializer = new JSONSerializer();

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        StringBuffer buffer = new StringBuffer();
        Vector<WebBusinessObject> data = null;
        int para = getOptName(request.getParameter("op").toString());

        try {
            switch (para) {
                case 2:
                     String resp = "1";
                    
                    String[] value = new String[3];
                    value[0] = "1403698261669";
                    value[1] = "4";
                    value[2] = "3";
                    
                    String[] key = new String[3];
                    key[0] = "key3";
                    key[1] = "key8";
                    EmployeeViewMgr employeeViewMgr = EmployeeViewMgr.getInstance();
                    data = employeeViewMgr.getComplaintsWithoutDate2(3, value, key, "key7", resp, 168, null, null);
                    break;
                case 1:
                    data = projectMgr.getOnArbitraryKey("div", "key4");
                    break;
                case 3:
                    data = projectMgr.getAllAvailableUnits();
                    break;
            }

            buffer.append("[");
            for (WebBusinessObject wbo : data) {
                buffer.append(wbo.getObjectAsJSON2());
                buffer.append(",");
            }
            buffer.deleteCharAt(buffer.lastIndexOf(","));
            buffer.append("]");
            System.out.println(data);
            response.getWriter().write(buffer.toString());
        } catch (SQLException ex) {
            Logger.getLogger(AndroidProjectServlet.class.getName()).log(Level.SEVERE, null, ex);
        } catch (Exception ex) {
            Logger.getLogger(AndroidProjectServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    protected int getOptName(String optName) {
        if (optName.equalsIgnoreCase("employeeAgendaDetails")) {
            return 2;
        } else if (optName.equalsIgnoreCase("default")) {
            return 1;
        } else if (optName.equalsIgnoreCase("getAvailableUnits")) {
            return 3;
        }
        return 0;
    }
    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
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
     * Handles the HTTP <code>POST</code> method.
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
}
