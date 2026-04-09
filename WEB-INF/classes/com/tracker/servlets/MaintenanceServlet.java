package com.tracker.servlets;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.silkworm.business_objects.*;
import java.util.*;
import java.sql.*;
import com.silkworm.util.*;
import com.silkworm.Exceptions.*;

import com.tracker.db_access.*;
import com.tracker.business_objects.*;
import com.silkworm.servlets.*;
import org.apache.log4j.Logger;

public class MaintenanceServlet extends swBaseServlet {
    MaintenanceMgr maintenanceMgr = MaintenanceMgr.getInstance();
    WebMaintenance wFun = new WebMaintenance();
    WebBusinessObject maintenanceWbo = null;
    
    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        servedPage = "/docs/Adminstration/newMaintenance.jsp";
        logger = Logger.getLogger(MaintenanceServlet.class);
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
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        super.processRequest(request, response);
        HttpSession s = request.getSession();
        String page =null;
        
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            if(this.requestHasNoParams(request)) {
                servedPage = "/docs/Adminstration/newMaintenance.jsp";
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
            } else {
                operation = getOpCode((String) request.getParameter("op"));
                
                switch (operation) {
                    case 1:
                        ArrayList requestAsArray = ServletUtils.getRequestParams(request);
                        ServletUtils.printRequest(requestAsArray);
                        servedPage = "/docs/Adminstration/newMaintenance.jsp";
                        
                        refineForm(request);
                        if(maintenanceMgr.saveObject(wFun, s))
                            request.setAttribute("Status" , "Ok");
                        else
                            request.setAttribute("Status", "No");
                        
                        request.setAttribute("page",servedPage);
                        this.forwardToServedPage(request, response);
                        break;
                        
                    case 2:
                        Vector maintenance = maintenanceMgr.getCashedTable();
                        servedPage = "/docs/Adminstration/maintenance_list.jsp";
                        
                        request.setAttribute("data", maintenance);
                        request.setAttribute("page",servedPage);
                        this.forwardToServedPage(request, response);
                        break;
                        
                    case 3:
                        String maintenanceName = request.getParameter("maintenanceName");
                        
                        servedPage = "/docs/Adminstration/confirm_del_maintenance.jsp";
                        
                        request.setAttribute("maintenanceName",maintenanceName);
                        request.setAttribute("page",servedPage);
                        this.forwardToServedPage(request, response);
                        break;
                        
                        
                    case 4:
                        WebBusinessObject maintenanceWbo = new WebBusinessObject();
                        servedPage = "/docs/Adminstration/view_maintenance.jsp";
                        maintenanceName = request.getParameter("maintenanceName");
                        
                        maintenanceWbo = maintenanceMgr.getOnSingleKey(maintenanceName);
                        request.setAttribute("maintenanceWbo",maintenanceWbo);
                        request.setAttribute("page",servedPage);
                        this.forwardToServedPage(request, response);
                        
                        break;
                        
                    case 5:
                        maintenanceName = request.getParameter("maintenanceName");
                        maintenanceWbo = maintenanceMgr.getOnSingleKey(maintenanceName);
                        
                        servedPage = "/docs/Adminstration/update_maintenance.jsp";
                        
                        request.setAttribute("maintenanceWbo", maintenanceWbo);
                        
                        request.setAttribute("page",servedPage);
                        this.forwardToServedPage(request, response);
                        break;
                        
                    case 6:
                        servedPage="/docs/Adminstration/update_maintenance.jsp";
                        
                        try {
                            
                            scrapeForm(request,"update");
                            
                            maintenanceWbo = new WebBusinessObject();
                            maintenanceWbo.setAttribute("maintenanceDesc",request.getParameter("maintenanceDesc"));
                            maintenanceWbo.setAttribute("maintenanceName",request.getParameter("maintenanceName"));
                            
                            // do update
                            maintenanceMgr.updateMaintenance(maintenanceWbo);
                            
                            // fetch the group again
                            shipBack("ok",request,response);
                            break;
                        }
                        
                        catch(EmptyRequestException ere) {
                            shipBack(ere.getMessage(),request,response);
                            break;
                        }
                        
                        
                        catch(SQLException sqlEx) {
                            shipBack(sqlEx.getMessage(),request,response);
                            break;
                        } catch(NoUserInSessionException nouser) {
                            shipBack(nouser.getMessage(),request,response);
                            break;
                        }
                        
                        catch(Exception Ex) {
                            shipBack(Ex.getMessage(),request,response);
                            break;
                        }
                        
                    case 7:
                        try{
                            IssueMgr issueMgr = IssueMgr.getInstance();
                            Integer iTemp = new Integer(issueMgr.hasData("FA_ID", request.getParameter("maintenanceName")));
                            if(iTemp.intValue() > 0) {
                                servedPage="/docs/Adminstration/cant_delete.jsp";
                                request.setAttribute("servlet", "MaintenanceServlet");
                                request.setAttribute("list", "ListMaintenance");
                                request.setAttribute("type", "Maintenance");
                                request.setAttribute("name", request.getParameter("maintenanceName"));
                                request.setAttribute("no", iTemp.toString());
                                request.setAttribute("page",servedPage);
                            } else {
                                maintenanceMgr.deleteOnSingleKey(request.getParameter("maintenanceName"));
                                maintenanceMgr.cashData();
                                maintenance = maintenanceMgr.getCashedTable();
                                servedPage = "/docs/Adminstration/maintenance_list.jsp";
                                
                                request.setAttribute("data", maintenance);
                                request.setAttribute("page",servedPage);
                            }
                            this.forwardToServedPage(request, response);
                        } catch(NoUserInSessionException ne) {
                        }
                        
                        break;
                    default:
                        this.forwardToServedPage(request, response);
                }
            }
        }
//        catch(SQLException sqlEx)
//        {
//            // forward to errot page
//        }
        catch(Exception sqlEx) {
            // forward to error page
            logger.error(sqlEx.getMessage());
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
    
    /** Returns a short description of the servlet.
     */
    public String getServletInfo() {
        return "Short description";
    }
    
    private void refineForm(HttpServletRequest request) {
        wFun.setMaintenanceName((String)request.getParameter("maintenanceName"));
        wFun.setMaintenanceDesc((String)request.getParameter("maintenanceDesc"));
    }
    
    protected int getOpCode(String opName) {
        
        if(opName.equalsIgnoreCase("SaveMaintenance"))
            return 1;
        
        if(opName.equalsIgnoreCase("ListMaintenance")) {
            return 2;
        }
        
        if(opName.equalsIgnoreCase("ConfirmDelete")) {
            return 3;
        }
        
        if(opName.equalsIgnoreCase("ViewMaintenance")) {
            return 4;
        }
        
        if(opName.equalsIgnoreCase("GetUpdateForm")) {
            return 5;
        }
        
        if(opName.equalsIgnoreCase("UpdateMaintenance")) {
            return 6;
        }
        
        if(opName.equalsIgnoreCase("Delete")) {
            return 7;
        }
        
        return 0;
    }
    
    private void scrapeForm(HttpServletRequest request,String mode) throws EmptyRequestException,EntryExistsException,SQLException,Exception {
        
        String maintenanceName = request.getParameter("maintenanceName");
        String maintenanceDesc = request.getParameter("maintenanceDesc");
        
        if(maintenanceName==null || maintenanceDesc.equals("")) {
            throw new EmptyRequestException(tGuide.getMessage("incompleteinput"));
        }
        
        if( maintenanceName.equals("") || maintenanceDesc.equals(""))
            throw new EmptyRequestException(tGuide.getMessage("incompleteinput"));
        
        if(mode.equalsIgnoreCase("insert")) {
            WebBusinessObject existingMaintenance =maintenanceMgr.getOnSingleKey(maintenanceName);
            
            if(existingMaintenance!=null)
                throw new EntryExistsException();
            
        }
    }
    
    private void shipBack(String message,HttpServletRequest request,HttpServletResponse response) {
        maintenanceWbo = maintenanceMgr.getOnSingleKey(request.getParameter("maintenanceName"));
        request.setAttribute("maintenanceWbo", maintenanceWbo);
        request.setAttribute("status",message);
        request.setAttribute("page",servedPage);
        this.forwardToServedPage(request, response);
        
    }
    
}
