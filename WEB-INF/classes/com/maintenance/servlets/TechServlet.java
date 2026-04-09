/*
 * TechServlet.java
 *
 * Created on February 6, 2007, 1:54 PM
 */

package com.maintenance.servlets;

import com.contractor.db_access.MaintainableMgr;
import com.maintenance.common.PeriodicCalcultaions;
import com.maintenance.db_access.ItemCatsMgr;
import com.maintenance.db_access.QuantifiedMntenceMgr;
import com.maintenance.db_access.ScheduleMgr;
import com.maintenance.db_access.TechMgr;
import com.maintenance.db_access.UnitScheduleMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.tracker.db_access.IssueMgr;
import com.tracker.servlets.TrackerBaseServlet;
import java.io.*;
import java.sql.SQLException;
import java.util.Calendar;
import java.util.Hashtable;
import java.util.Vector;

import javax.servlet.*;
import javax.servlet.http.*;

/**
 *
 * @author image
 * @version
 */
public class TechServlet extends TrackerBaseServlet {
    
    TechMgr techMgr;
    
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }
    
    public void destroy() {
        
    }
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        super.processRequest(request,response);
        HttpSession session = request.getSession();
        
        switch(operation) {
            case 1:
                try {
                    servedPage = "/docs/Adminstration/new_tech.jsp";
                    request.setAttribute("page",servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                } catch(Exception e) {
                    System.out.println("General Exception "+e.getMessage());
                }
                break;
                
            case 2:
                servedPage = "/docs/Adminstration/new_tech.jsp";
                WebBusinessObject wUser = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
                Hashtable hash = new Hashtable();
                hash.put("techName", request.getParameter("techName"));
                hash.put("techJob", request.getParameter("techJob"));
                hash.put("createdBy", wUser.getAttribute("userId").toString());
                techMgr = TechMgr.getInstance();
                
                try {
                    if(techMgr.saveObject(hash)){
                        request.setAttribute("Status", "OK");
                    }
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
                techMgr.cashData();
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 3:
                techMgr = TechMgr.getInstance();
                Vector techs = techMgr.getCashedTable();
                System.out.println("sa ----------------- ");
                servedPage = "/docs/Adminstration/tech_list.jsp";
                
                request.setAttribute("data", techs);
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 4:
                servedPage = "/docs/Adminstration/view_tech.jsp";
                String techId = request.getParameter("techId");
                techMgr = TechMgr.getInstance();
                WebBusinessObject tech = techMgr.getOnSingleKey(techId);
                request.setAttribute("tech",tech);
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                
                break;
                
            case 5:
                String techName = request.getParameter("techName");
                techId = request.getParameter("techId");
                
                servedPage = "/docs/Adminstration/confirm_deltech.jsp";
                
                request.setAttribute("techName",techName);
                request.setAttribute("techId",techId);
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 6:
                techMgr = TechMgr.getInstance();
                techMgr.deleteOnSingleKey(request.getParameter("techId"));
                techMgr.cashData();
                techs = techMgr.getCashedTable();
                servedPage = "/docs/Adminstration/tech_list.jsp";
                
                request.setAttribute("data", techs);
                request.setAttribute("page",servedPage);
                
                this.forwardToServedPage(request, response);
                
                break;
                
            case 7:
                techId = request.getParameter("techId");
                techMgr = TechMgr.getInstance();
                tech = techMgr.getOnSingleKey(techId);
                
                servedPage = "/docs/Adminstration/update_tech.jsp";
                
                request.setAttribute("tech",tech);
                
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 8:
                servedPage="/docs/Adminstration/update_tech.jsp";
                
                tech = new WebBusinessObject();
                tech.setAttribute("techName",request.getParameter("techName"));
                tech.setAttribute("jobTitle",request.getParameter("jobTitle"));
                tech.setAttribute("techID",request.getParameter("techID"));
                
                techMgr = TechMgr.getInstance();
                if(techMgr.updateTech(tech)){
                    request.setAttribute("status", "Ok");
                }
                tech = techMgr.getOnSingleKey(request.getParameter("techID"));
                request.setAttribute("tech", tech);
                
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
                
                
            default:
                System.out.println("No operation was matched");
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
        return "Search Servlet";
    }
    
    protected int getOpCode(String opName) {
        if(opName.indexOf("GetTechForm") == 0)
            return 1;
        
        if(opName.indexOf("Create") == 0)
            return 2;
        
        if(opName.indexOf("ListTechnicians") == 0)
            return 3;
        
        if(opName.indexOf("ViewTechnician") == 0)
            return 4;
        
        if(opName.indexOf("ConfirmDelete") == 0)
            return 5;
        
        if(opName.equalsIgnoreCase("Delete"))
            return 6;
        
        if(opName.equalsIgnoreCase("GetUpdateForm"))
            return 7;
        
        if(opName.equalsIgnoreCase("UpdateTech"))
            return 8;
        
        return 0;
    }
}
