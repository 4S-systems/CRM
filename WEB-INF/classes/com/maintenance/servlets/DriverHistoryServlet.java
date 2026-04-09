package com.maintenance.servlets;

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

public class DriverHistoryServlet extends TrackerBaseServlet {

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
                servedPage = "/docs/equipment/attach_driver.jsp";
                MaintainableMgr maintainableMgr = MaintainableMgr.getInstance();
                EmpBasicMgr empBasicMgr = EmpBasicMgr.getInstance();
              //  ArrayList arrEquipments = maintainableMgr.getAttachableEquipment();

                request.setAttribute("listWorkers", empBasicMgr.getCashedTableAsBusObjects());
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 2:
                DriversHistoryMgr driversHistoryMgr = DriversHistoryMgr.getInstance();
                if (driversHistoryMgr.saveObject(request,session)) {
                    request.setAttribute("Status", "Ok");
                } else {
                    request.setAttribute("Status", "No");
                }
                servedPage = "/docs/equipment/attach_driver.jsp";
                maintainableMgr = MaintainableMgr.getInstance();
                 empBasicMgr = EmpBasicMgr.getInstance();
              //  arrEquipments = maintainableMgr.getAttachableEquipment();

               request.setAttribute("listWorkers", empBasicMgr.getCashedTableAsBusObjects());
                request.setAttribute("page", servedPage);


                this.forwardToServedPage(request, response);

                break;
                
                
                case 3:
                String driverHistoryId =request.getParameter("id");
                servedPage = "/docs/equipment/attach_driver.jsp";
                 maintainableMgr = MaintainableMgr.getInstance();
                 empBasicMgr = EmpBasicMgr.getInstance();
                 driversHistoryMgr = DriversHistoryMgr.getInstance();
                 if (driversHistoryMgr.updateDriverHistory(request,driverHistoryId,session)) {
                    driversHistoryMgr.saveObject(request,session);
                     request.setAttribute("Status", "Ok");
                } else {
                    request.setAttribute("Status", "No");
                }
                 
                 
              //  ArrayList arrEquipments = maintainableMgr.getAttachableEquipment();

                request.setAttribute("listWorkers", empBasicMgr.getCashedTableAsBusObjects());
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

             case 4:
                String unitId=request.getParameter("equipmentID").toString();
                Vector vecDriver=new Vector(); 
                servedPage = "/docs/equipment/list_attach_driver_.jsp";
                driversHistoryMgr= DriversHistoryMgr.getInstance();

                try {
                    vecDriver=driversHistoryMgr.getOnArbitraryKey(unitId,"key1");
                } catch (SQLException ex) {
                    ex.printStackTrace();
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
                
                maintainableMgr = MaintainableMgr.getInstance();
                 empBasicMgr = EmpBasicMgr.getInstance();
                 
              //  ArrayList arrEquipments = maintainableMgr.getAttachableEquipment();

                request.setAttribute("listWorkers", empBasicMgr.getCashedTableAsBusObjects());
                request.setAttribute("vecDriver", vecDriver);
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
        return "Driver History Servlet";
    }

    protected int getOpCode(String opName) {
        if (opName.equals("GetAttachDriverForm")) {
            return 1;
        }

        if (opName.equals("SaveAttachDriver")) {
            return 2;
        }
        
        if (opName.equals("CloseAttachDriver")) {
            return 3;
        }
        
         if (opName.equals("ListAttachDriverForm")) {
            return 4;
        }

        return 0;
    }
}
