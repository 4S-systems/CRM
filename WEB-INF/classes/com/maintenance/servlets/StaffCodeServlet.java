package com.maintenance.servlets;

import java.awt.image.BufferedImage;
import java.io.*;
import java.util.*;

import javax.servlet.*;
import javax.servlet.http.*;

import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.Exceptions.*;
import com.tracker.servlets.TrackerBaseServlet;

import com.maintenance.db_access.*;

import com.contractor.db_access.MaintainableMgr;
import com.silkworm.persistence.relational.UniqueIDGen;
import javax.imageio.ImageIO;
//import com.maintenance.db_access.ItemMgr;

public class StaffCodeServlet extends TrackerBaseServlet{
    MaintainableMgr unit =  MaintainableMgr.getInstance();
    ItemCatsMgr itemCatsMgr = ItemCatsMgr.getInstance();
    CategoryMgr categoryMgr=CategoryMgr.getInstance();
    ItemMgr itemMgr = ItemMgr.getInstance();
    StaffCodeMgr staffCodeMgr = StaffCodeMgr.getInstance();
    CrewMissionMgr crewMissionMgr = CrewMissionMgr.getInstance();
    
    String op = null;
    String filterName = null;
    String filterValue = null;
    String categoryId=null;
    
    Vector unitsList = null;
    ArrayList unitArr;
    ArrayList itemCategory;
    
    
    
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
                servedPage = "/docs/Adminstration/new_staff_code.jsp";
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 2:
               
                String crewCode = null;
                String crewName=null;
                WebBusinessObject crewWbo = crewMissionMgr.getOnSingleKey(request.getParameter("crewID").toString());
                crewName = crewWbo.getAttribute("crewName").toString();
                crewCode = crewName+"-"+request.getParameter("code").toString();
                
                servedPage = "/docs/Adminstration/new_staff_code.jsp";
                WebBusinessObject staff = new WebBusinessObject();
                staff.setAttribute("code",request.getParameter("code").toString());
                staff.setAttribute("crewID",request.getParameter("crewID").toString());
                staff.setAttribute("description",request.getParameter("description").toString());
                
                
                try {
                     if(!staffCodeMgr.getDoubleName(crewCode)) {
                    if(staffCodeMgr.saveObject(staff, session,crewCode))
                        
                        request.setAttribute("Status" , "Ok");
                    else
                        request.setAttribute("Status", "No");
                    
                }else {
                            request.setAttribute("Status", "No");
                            request.setAttribute("name", "Duplicate Name");
                        }
                    } catch (NoUserInSessionException ex) {
                        ex.printStackTrace();
                    } catch (Exception ex) {
                        ex.printStackTrace();
                    }
                
                
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
                
                
            case 3:
                Vector staffCode=new Vector();
                staffCodeMgr.cashData();
                staffCode = staffCodeMgr.getCashedTable();
                System.out.println("sa ----------------- ");
                servedPage = "/docs/Adminstration/Staff_code_List.jsp";
                
                request.setAttribute("data", staffCode);
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 4:
                String staffCodeId=null;
                servedPage = "/docs/Adminstration/view_Staff_Code.jsp";
                staffCodeId = request.getParameter("staffCodeId");           
                staff = staffCodeMgr.getOnSingleKey(staffCodeId);
                request.setAttribute("staff",staff);
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                
                break;
                
            case 5:

                staffCodeId = request.getParameter("staffCodeId");
                staff = staffCodeMgr.getOnSingleKey(staffCodeId);               
                servedPage = "/docs/Adminstration/update_staff_code.jsp";
          
                request.setAttribute("staff",staff);
                request.setAttribute("staffCodeId",staffCodeId);

                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
                
                
            case 6:
                String crewId = null;
                crewWbo = crewMissionMgr.getOnSingleKey(request.getParameter("crewID").toString());
                crewName = crewWbo.getAttribute("crewName").toString();
                crewId = crewWbo.getAttribute("crewID").toString();
                crewCode = crewName+"-"+request.getParameter("code").toString();
                
                
                staffCodeId = request.getParameter("staffCodeId");
                servedPage="/docs/Adminstration/update_staff_code.jsp";
                
                staff= new WebBusinessObject();
                staff.setAttribute("code",request.getParameter("code").toString());
                staff.setAttribute("description",request.getParameter("description").toString());
                staff.setAttribute("crewId",crewId);
                staff.setAttribute("staffCodeId",request.getParameter("staffCodeId").toString());
//                
             try {
                     if(!staffCodeMgr.getDoubleNameforUpdate(staffCodeId,crewCode)) {
                if(staffCodeMgr.updateStaffCode(staff, session,crewCode))
                    request.setAttribute("Status" , "Ok");
                    else
                        request.setAttribute("Status", "No");
                    
                }else {
                            request.setAttribute("Status", "No");
                            request.setAttribute("name", "Duplicate Name");
                        }
                    } catch (NoUserInSessionException ex) {
                        ex.printStackTrace();
                    } catch (Exception ex) {
                        ex.printStackTrace();
                    }
                
                staff = staffCodeMgr.getOnSingleKey(request.getParameter("staffCodeId"));
                request.setAttribute("staff", staff);   
                request.setAttribute("staffCodeId", staffCodeId);        
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 7:
                String staffTitle = request.getParameter("staffTitle");
                staffCodeId = request.getParameter("staffCodeId");
                
                servedPage = "/docs/Adminstration/confirm_delStaffCode.jsp";
                
                request.setAttribute("staffTitle",staffTitle);
                request.setAttribute("staffCodeId",staffCodeId);
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 8:
                staffCode = categoryMgr.getCashedTable();
                staffCodeMgr.deleteOnSingleKey(request.getParameter("staffCodeId"));
                staffCodeMgr.cashData();
//                
                staffCode = staffCodeMgr.getCashedTable();
                servedPage = "/docs/Adminstration/Staff_code_List.jsp";
                
                request.setAttribute("data", staffCode);
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
        if(opName.indexOf("GetStaffCode") == 0)
            return 1;
        
        if(opName.indexOf("SaveStaffCode") == 0)
            return 2;
        
        if(opName.equals("ListStaffCode"))
            return 3;
        
        if(opName.equals("ViewStaffCode"))
            return 4;
        
        if(opName.equals("GetUpdateStaffCode"))
            return 5;
        
        if(opName.equals("UpdateStaffCode"))
            return 6;
        
        if(opName.equals("ConfirmDeleteStaffCode"))
            return 7;
        
        if(opName.equals("Delete"))
            return 8;
        
        return 0;
    }
}

