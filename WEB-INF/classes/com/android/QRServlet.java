/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.android;

import com.businessfw.hrs.db_access.EmployeeMgr;
import com.maintenance.common.Tools;
import com.maintenance.db_access.IssueDocumentMgr;
import com.maintenance.db_access.UnitDocMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.db_access.FileMgr;
import com.tracker.db_access.ProjectMgr;
import java.io.IOException;
import java.io.OutputStreamWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author asteriskpbx
 */
public class QRServlet extends HttpServlet
{

    int operation;
    ProjectMgr projectMgr = ProjectMgr.getInstance();
    EmployeeMgr empMgr = EmployeeMgr.getInstance();
    IssueDocumentMgr docMgr = IssueDocumentMgr.getInstance();
    UnitDocMgr unitDocMgr = UnitDocMgr.getInstance();
    FileMgr fileMgr = FileMgr.getInstance();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
        response.setContentType("text/html;charset=UTF-8");
        operation = getOpCode((String) request.getParameter("op"));
        switch (operation)
        {
            case 1:
            {
                OutputStreamWriter out = new OutputStreamWriter(response.getOutputStream());
                String unitId = request.getParameter("unitId");
                WebBusinessObject unitWebo = (WebBusinessObject) projectMgr.getOnSingleKey(unitId);
                out = new OutputStreamWriter(response.getOutputStream());
                out.write(Tools.getJSONObjectAsString(unitWebo));
                out.close();
                break;
            }
        }
    }

    protected int getOpCode(String opName)
    {
        if (opName.equals("getUnit"))
        {
            return 1;
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
            throws ServletException, IOException
    {
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
            throws ServletException, IOException
    {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo()
    {
        return "Short description";
    }// </editor-fold>

}
