package com.maintenance.servlets;

import com.silkworm.business_objects.WebBusinessObject;
import java.io.*;
import java.net.*;
import java.sql.SQLException;
import java.util.*;

import javax.servlet.*;
import javax.servlet.http.*;

import com.silkworm.jsptags.*;
import com.silkworm.Exceptions.*;
import com.silkworm.persistence.relational.*;

import com.tracker.common.*;
import com.tracker.db_access.*;
import com.tracker.servlets.TrackerBaseServlet;

import com.maintenance.db_access.*;
import com.maintenance.common.*;

import com.contractor.db_access.MaintainableMgr;
import java.util.ArrayList;

public class SupplementServlet extends TrackerBaseServlet {
    
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }
    
    public void destroy() {
    }
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        super.processRequest(request, response);
        HttpSession session = request.getSession();
        ArrayList tempList = new ArrayList();
        ArrayList categoryList = new ArrayList();
        
        switch (operation) {
            case 1:
                SupplementMgr supplementMgr = SupplementMgr.getInstance();
                servedPage = "/docs/equipment/attach_equipment.jsp";
                MaintainableMgr maintainableMgr = MaintainableMgr.getInstance();
                ArrayList arrEquipments = maintainableMgr.getAttachableEquipment();
                  
                WebBusinessObject wbo=new WebBusinessObject();
                Vector allowed_Attached_eqps=new Vector();
                String temp="";
                for(int i=0;i<arrEquipments.size();i++) {
                    wbo=(WebBusinessObject)arrEquipments.get(i);
                    String id=wbo.getAttribute("id").toString();
                    allowed_Attached_eqps=supplementMgr.searchAllowedEqps(id);
                    if(allowed_Attached_eqps.size()>0) {
                        arrEquipments.remove(i);
                        i--;
                    }
                }
                
                request.setAttribute("arrEquipments", arrEquipments);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 2:
                supplementMgr = SupplementMgr.getInstance();
                if (supplementMgr.saveObject(request)) {
                    request.setAttribute("Status", "Ok");
                } else {
                    request.setAttribute("Status", "No");
                }
                servedPage = "/docs/equipment/attach_equipment.jsp";
                maintainableMgr = MaintainableMgr.getInstance();
                arrEquipments = maintainableMgr.getAttachableEquipment();
                wbo=new WebBusinessObject();
                allowed_Attached_eqps=new Vector();
                temp="";
                for(int i=0;i<arrEquipments.size();i++) {
                    wbo=(WebBusinessObject)arrEquipments.get(i);
                    String id=wbo.getAttribute("id").toString();
                    allowed_Attached_eqps=supplementMgr.searchAllowedEqps(id);
                    if(allowed_Attached_eqps.size()>0) {
                        arrEquipments.remove(i);
                        i--;
                    }
                }
                
                request.setAttribute("arrEquipments", arrEquipments);
                request.setAttribute(
                        "page", servedPage);
                
                
                this.forwardToServedPage(request, response);
                
                break;
                
            case 3:
                servedPage = "/docs/equipment/Separate_equipment.jsp";
                maintainableMgr = MaintainableMgr.getInstance();
                supplementMgr =SupplementMgr.getInstance();
//                arrEquipments = maintainableMgr.getAttachableEquipment();
                
                String EID=(String)request.getParameter("EID");
                Vector allAttachedEqps=new Vector();
                
                try {
                    
                    allAttachedEqps= supplementMgr.getOnArbitraryKey(EID,"key1");
                    
                } catch (SQLException ex) {
                    ex.printStackTrace();
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
                
                request.setAttribute("currentMode",request.getParameter("currentMode"));
                request.setAttribute("equipmentID",EID);
                request.setAttribute("allAttachedEqps", allAttachedEqps);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 4:
                supplementMgr = SupplementMgr.getInstance();
                EID=(String)request.getParameter("equipmentID");
                if (supplementMgr.separateEquipments(request)) {
                    request.setAttribute("Status", "Ok");
                } else {
                    request.setAttribute("Status", "No");
                }
                servedPage = "/docs/equipment/Separate_equipment.jsp";
                maintainableMgr = MaintainableMgr.getInstance();
                arrEquipments = maintainableMgr.getAttachableEquipment();
                
                allAttachedEqps=new Vector();
                try {
                    allAttachedEqps= supplementMgr.getOnArbitraryKey(EID,"key1");
                } catch (SQLException ex) {
                    ex.printStackTrace();
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
                
                request.setAttribute("equipmentID",EID);
                request.setAttribute("allAttachedEqps", allAttachedEqps);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                
                break;
                
            case 5:
                supplementMgr = SupplementMgr.getInstance();
                String isEqMain=(String)request.getParameter("ismain");
                EID=(String)request.getParameter("equipmentID");
                servedPage = "/docs/equipment/attached_history.jsp";
                maintainableMgr=MaintainableMgr.getInstance();
                allAttachedEqps=new Vector();
                Vector eqData=new Vector();
                Vector attched_eqps=new Vector();
                Row row=null;
                wbo=new WebBusinessObject();
                temp="";
                String unitName="";
                try {
                    // Vector attched_eqps=supplementMgr.getOnArbitraryKeyOracle(EID,"key1");
                    if(isEqMain.equalsIgnoreCase("main")){
                        attched_eqps=supplementMgr.getAllAttachedEqps(EID);
                    } else{
                        attched_eqps=supplementMgr.getAllSupplementedEqps(EID);
                    }
                    
                    for(int i=0;i<attched_eqps.size();i++) {
                        eqData=new Vector();
                        wbo=(WebBusinessObject)attched_eqps.get(i);
                        temp=wbo.getAttribute("notes").toString();
                        eqData.add(temp);
                        temp=wbo.getAttribute("separation_date").toString();
                        eqData.add(temp);
                        temp=wbo.getAttribute("attachmentDate").toString();
                        eqData.add(temp);
                        temp=wbo.getAttribute("supplementEqpID").toString();
                        
                        wbo=maintainableMgr.getOnSingleKey(temp);
                        unitName=wbo.getAttribute("unitName").toString();
                        eqData.add(unitName);
                        allAttachedEqps.add(eqData);
                        temp="";
                        
                    }
                    
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
                wbo=maintainableMgr.getOnSingleKey(EID);
                request.setAttribute("equipmentID",EID);
                request.setAttribute("equipmentName",wbo.getAttribute("unitName").toString());
                request.setAttribute("allAttachedEqps", allAttachedEqps);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                
                break;
                
        case 6:
                supplementMgr = SupplementMgr.getInstance();
                servedPage = "/docs/equipment/attach_equipment.jsp";
                maintainableMgr = MaintainableMgr.getInstance();
                arrEquipments = maintainableMgr.getAttachableEquipment();

                wbo=new WebBusinessObject();
                allowed_Attached_eqps=new Vector();
               

                request.setAttribute("arrEquipments", arrEquipments);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            default:
                System.out.println(
                        "No operation was matched");
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
        return "Supplement Parts Servlet";
    }
    
    protected int getOpCode(String opName) {
        if (opName.equals("GetAttachEqForm")) {
            return 1;
        }
        
        if (opName.equals("SaveAttachEquipment")) {
            return 2;
        }
        if (opName.equals("GetSeparateEqForm")) {
            return 3;
        }
        
        if (opName.equals("SaveSeparateEquipment")) {
            return 4;
        }
        if (opName.equals("viewAttachedHistory")) {
            return 5;
        }
         if (opName.equals("viewListAttachedHistory")) {
            return 5;
        }
        
        return 0;
    }
}
