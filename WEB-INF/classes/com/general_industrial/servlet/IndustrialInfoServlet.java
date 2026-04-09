/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.general_industrial.servlet;

import com.general_industrial.db_access.ManufactoryMgr;
import com.silkworm.business_objects.WebBusinessObject;
import java.io.*;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.*;
import javax.servlet.http.*;




import com.silkworm.servlets.swBaseServlet;
import java.util.Vector;

/**
 *
 * @author  walid
 * @version
 */
public class IndustrialInfoServlet extends swBaseServlet {

    /** Initializes the servlet.
     */
    private ServletContext context;
    Vector meufacturer;

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);

    }

    /** Destroys the servlet.
     */
    @Override
    public void destroy() {
    }

    /** Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     */
    @Override
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        super.processRequest(request, response);
        operation = getOpCode((String) request.getParameter("op"));
        ManufactoryMgr manufactoryMgr = ManufactoryMgr.getInstance();

        switch (operation) {
            case 1:
                servedPage = "/docs/manufacturer/manufacturerInsert.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 2:
                WebBusinessObject wbo = new WebBusinessObject();
                wbo.setAttribute("EN_Name", request.getParameter("EN_Name"));
                wbo.setAttribute("Country", request.getParameter("Country"));
                wbo.setAttribute("Ar_Name", request.getParameter("Ar_Name"));
                wbo.setAttribute("ABBREVIATION_NAME", request.getParameter("ABBREVIATION_NAME"));
                wbo.setAttribute("REMARKS", request.getParameter("REMARKS"));
                try {
                    manufactoryMgr.saveObject(wbo);
                    request.setAttribute("status", "Success");
                } catch (SQLException ex) {
                    Logger.getLogger(IndustrialInfoServlet.class.getName()).log(Level.SEVERE, null, ex);
                    request.setAttribute("status", "Fail");
                }
                this.forward("IndustrialInfo?op=searchIndustrial", request, response);
                break;
            case 3:
//                String da=request.getParameter("q");                
//                request.setAttribute("da", da);
//                this.forward("/docs/manufacturer/resault.jsp", request, response);

                meufacturer = manufactoryMgr.getCashedTable();
                servedPage = "/docs/manufacturer/manufacturerSearch.jsp";
                request.setAttribute("data", meufacturer);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 4:
                servedPage = "/docs/manufacturer/view.jsp";
                meufacturer = manufactoryMgr.getCashedTable();
                Vector manufacturersList = (Vector) meufacturer;
                String count = Integer.toString(manufacturersList.size());
                request.setAttribute("count", count);
                request.setAttribute("index", new String(request.getParameter("index")));
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);

                break;
            case 5:

                String Id = (String) request.getParameter("id");
                int iId = Integer.parseInt(Id);
                Id = manufactoryMgr.getIdRecordByIndex(iId);
                WebBusinessObject meufactureWBO = manufactoryMgr.getOnSingleKey(Id);
                request.setAttribute("data", meufactureWBO);
                this.forward("/docs/manufacturer/resault.jsp", request, response);


                break;
            case 6:
                String key = request.getParameter("menufactorID");
                servedPage = "/docs/manufacturer/confirmDelete.jsp";
                meufactureWBO = manufactoryMgr.getOnSingleKey(key);
                request.setAttribute("menufactorID", key);
                request.setAttribute("data", meufactureWBO);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 7:
                key = request.getParameter("menufactorID");
                servedPage = "/docs/manufacturer/manufacturerUpdate.jsp";
                meufactureWBO = manufactoryMgr.getOnSingleKey(key);
                request.setAttribute("menufactorID", key);
                request.setAttribute("data", meufactureWBO);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 8:
                key = request.getParameter("menufactorID");
                manufactoryMgr.deleteOnSingleKey(key);
                this.forward("IndustrialInfo?op=searchIndustrial", request, response);
                break;
            case 9:
               wbo = new WebBusinessObject();
                wbo.setAttribute("EN_Name", request.getParameter("EN_Name"));
                wbo.setAttribute("Country", request.getParameter("Country"));
                wbo.setAttribute("Ar_Name", request.getParameter("Ar_Name"));
                wbo.setAttribute("ABBREVIATION_NAME", request.getParameter("ABBREVIATION_NAME"));
                wbo.setAttribute("REMARKS", request.getParameter("REMARKS"));
                wbo.setAttribute("ID", request.getParameter("ID"));
                manufactoryMgr.updateManufactoryMgr(wbo);
                request.setAttribute("status", "Success");
                this.forward("IndustrialInfo?op=searchIndustrial", request, response);
                break;
            default:
                break;
        }
    }

    @Override
    public String getServletInfo() {
        return "Group Servlet";
    }

    @Override
    protected int getOpCode(String opName) {
        if (opName.equalsIgnoreCase("GetForm")) {
            return 1;
        }

        if (opName.equalsIgnoreCase("SaveIndustrial")) {
            return 2;
        }
        if (opName.equalsIgnoreCase("searchIndustrial")) {
            return 3;
        }
        if (opName.equalsIgnoreCase("viewIndustrial")) {
            return 4;
        }
        if (opName.equalsIgnoreCase("getresault")) {
            return 5;
        }
        if (opName.equalsIgnoreCase("GetUpdateForm")) {
            return 7;
        }
        if (opName.equalsIgnoreCase("delete")) {
            return 6;
        }
        if (opName.equalsIgnoreCase("deleteIndustrial")) {
            return 8;
        }
        if (opName.equalsIgnoreCase("updateIndustrial")) {
            return 9;
        }
        return 0;
    }
}
