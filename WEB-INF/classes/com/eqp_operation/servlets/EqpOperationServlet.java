/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.eqp_operation.servlets;

import com.contractor.db_access.MaintainableMgr;
import com.eqp_operation.db_access.EqpOperationMgr;
import com.maintenance.common.Tools;
import com.maintenance.db_access.AverageUnitMgr;
import com.maintenance.db_access.MainCategoryTypeMgr;
import com.silkworm.Exceptions.NoUserInSessionException;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.project_doc.SelfDocMgr;
import com.tracker.servlets.TrackerBaseServlet;
import java.io.IOException;

import java.util.ArrayList;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
/**
 *
 * @author Administrator
 */
public class EqpOperationServlet extends TrackerBaseServlet {

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
        HttpSession session = request.getSession();
        AverageUnitMgr averageUnitMgr = AverageUnitMgr.getInstance();
        WebBusinessObject averageUpdate = new WebBusinessObject();
        MaintainableMgr maintainableMgr = null;
        WebBusinessObject Average = null;
        WebBusinessObject inputData = null;
        WebBusinessObject inputData1 = null;
        EqpOperationMgr eqpOperationMgr = EqpOperationMgr.getInstance();
        String EquipId = request.getParameter("parentCategory");
        String CategoryID = request.getParameter("mainCategoryType");
        ArrayList categoryList = new ArrayList();
        ArrayList mainCategoryList = new ArrayList();
        MainCategoryTypeMgr mainCategoryTypeMgr = null;

        try {
            switch (operation) {
                case 1:
                    List TestEquip = eqpOperationMgr.getAllEquipByID(EquipId);
                    maintainableMgr = MaintainableMgr.getInstance();
                    mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();
                    mainCategoryList = mainCategoryTypeMgr.getAllAsArrayList();
                    if (!mainCategoryList.isEmpty()) {
                        categoryList = Tools.toArrayList(maintainableMgr.getParentIdAndName(CategoryID));
                    }
                    servedPage = "/docs/equipment/operation/equipment_Data.jsp";
                    request.setAttribute("EquipID", EquipId);
                    request.setAttribute("CategoryID", CategoryID);
                    request.setAttribute("mainCategoryList", mainCategoryList);
                    request.setAttribute("categoryList", categoryList);
                    request.setAttribute("ListOfEquip", TestEquip);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 2:
                    Average = new WebBusinessObject();
                    long now = timenow();
                    maintainableMgr = MaintainableMgr.getInstance();
                    mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();
                    mainCategoryList = mainCategoryTypeMgr.getAllAsArrayList();
                    if (!mainCategoryList.isEmpty()) {
                        categoryList = Tools.toArrayList(maintainableMgr.getParentIdAndName(CategoryID));
                    }
                    String numOfRows = request.getParameter("checkBox");
                    int numRows = Integer.parseInt(numOfRows);
                    String check = null;
                    for (int i = 0; i <= numRows; i++) {
                        check = request.getParameter("check_list" + i);
                        if (check != null) {
                            Average.setAttribute("current_Reading", request.getParameter("currentReading" + i));
                            Average.setAttribute("description", "test");
                            Average.setAttribute("unit", check);
                            String checkUpdate = averageUnitMgr.getTrueUpdate(check);
                            if (checkUpdate != null) {
                                averageUpdate = averageUnitMgr.getOnSingleKey(checkUpdate);
                                String prevDate = request.getParameter("Entry_time" + i);
                                if (averageUnitMgr.updateAverage(Average, averageUpdate, prevDate, now)) {
                                    request.setAttribute("Status", "Ok");
                                    System.out.println("Save Done");
                                } else {
                                    request.setAttribute("Status", "No");
                                    System.out.println("Error Happened");
                                }
                            } else {
                                try {
                                    if (averageUnitMgr.saveObject(Average, session, now)) {
                                        request.setAttribute("Status", "Ok");
                                    } else {
                                        request.setAttribute("Status", "No");
                                    }
                                } catch (NoUserInSessionException ex) {
                                    Logger.getLogger(EqpOperationServlet.class.getName()).log(Level.SEVERE, null, ex);
                                }

                            }
                        }
                    }
                    servedPage = "/docs/equipment/operation/equipment_Data.jsp";
                    request.setAttribute("mainCategoryList", mainCategoryList);
                    request.setAttribute("categoryList", categoryList);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 3:
                    servedPage = "docs/new_report/form_details.jsp";
                    SelfDocMgr selfDocMgr = SelfDocMgr.getInstance();
                    Vector<WebBusinessObject> formsWbo = new Vector<WebBusinessObject>();
                    String formCode = request.getParameter("formCode");
                    formsWbo = selfDocMgr.getFormsList(formCode);
                    request.setAttribute("formsWbo", formsWbo);
                    this.forward(servedPage, request, response);
                    break;
            }
        } catch (Exception ex) {
            logger.error(ex.getMessage());
        }




    }

    private long timenow() {
        Date d = Calendar.getInstance().getTime();
        long nowTime = d.getTime();
        return nowTime;
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

    protected int getOpCode(String opName) {
        if (opName.equals("showTestPage")) {
            return 1;
        }
        if (opName.equals("saveAverageUnit")) {
            return 2;
        }
        if(opName.equalsIgnoreCase("getFormDetails")){
            return 3;
        }
        return 0;
    }
}
