package com.maintenance.servlets;

import com.DatabaseController.db_access.DatabaseControllerMgr;
import com.SpareParts.db_access.*;
import com.contractor.db_access.MaintainableMgr;
import com.maintenance.common.Tools;
import com.maintenance.db_access.ItemFormListMgr;
import com.maintenance.db_access.ReconfigTaskMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.common.SecurityUser;
import com.silkworm.common.URLUtils;
import com.tracker.db_access.ProjectMgr;
import com.tracker.db_access.TotalTicketsMgr;
import java.io.*;

import javax.servlet.*;
import javax.servlet.http.*;
import com.tracker.servlets.TrackerBaseServlet;
import java.util.Vector;

public class ajaxServlet extends TrackerBaseServlet {

    DatabaseControllerMgr databaseControllerMgr = DatabaseControllerMgr.getInstance();
    ItemFormListMgr itemFormListMgr = ItemFormListMgr.getInstance();
    ReconfigTaskMgr reconfigTaskMgr = ReconfigTaskMgr.getInstance();
    MaintainableMgr maintainableMgr = MaintainableMgr.getInstance();
    ERPDistNamesMgr erpDistNamesMgr = ERPDistNamesMgr.getInstance();
    TotalTicketsMgr totalTicketsMgr = TotalTicketsMgr.getInstance();
    String ownerName, path, width, height, responseText, storeId, branchId, issueId, itemCode, mainCategoryId, unitId, unitName;
    String[] taskIds, quantitys;
    Vector itemFormList, categoryList;
    WebBusinessObject wbo;

    @Override
    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        super.processRequest(request, response);
        HttpSession session = request.getSession();
        SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");
        PrintWriter writer = response.getWriter();

        switch (operation) {
            case 1:
                ownerName = request.getParameter("ownerName");
                boolean isSchemaFound = databaseControllerMgr.isSchemaFound(ownerName);

                if (isSchemaFound) {
                    writer.write("yes");
                } else {
                    writer.write("no");
                }
                break;

            case 2:
                path = request.getParameter("path");
                width = request.getParameter("width");
                height = request.getParameter("height");
                File file = new File(path);
                responseText = file.exists() + "<&&>" + width + "<&&>" + height;
                writer.write(responseText);
                break;

            case 3:
                storeId = request.getParameter("storeId");
                itemFormList = new Vector();
                responseText = "";
                String formDesc, codeForm;

                branchId = itemFormListMgr.getBranchByStoreCode(storeId);
                // set branch code in response as <data>banch value<data><element>code form<subelement>form desc. ..............
                responseText = branchId + "<data>";

                try {
                    itemFormList = itemFormListMgr.getOnArbitraryKey(storeId, "key1");
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }

                for (int i = 0; i < itemFormList.size(); i++) {
                    wbo = (WebBusinessObject) itemFormList.get(i);
                    formDesc = (String) wbo.getAttribute("formDesc");
                    codeForm = (String) wbo.getAttribute("codeForm");

                    responseText += codeForm + "<subelement>" + formDesc;
                    if (i < itemFormList.size() - 1) {
                        responseText += "<element>";
                    }
                }

                writer.write(responseText);
                break;

            case 4:
                databaseControllerMgr.IgnoreDBError();
                break;
                
            case 5:
                issueId = request.getParameter("issueId");
                itemCode = request.getParameter("itemCode");
                String tempTasks = request.getParameter("tasks").trim();
                String tempQuantity = request.getParameter("quantitys").trim();
                
                taskIds = tempTasks.split("@@");
                quantitys = tempQuantity.split("@@");
                
                // all old config. for this pand
                try {
                    reconfigTaskMgr.deleteOnArbitraryKey(itemCode, "key3");
                } catch(Exception ex) { logger.error(ex.getMessage()); }
                
                responseText = "";
                if(reconfigTaskMgr.saveObjects(issueId, itemCode, taskIds, quantitys)) {
                    responseText = "ok";
                } else {
                    responseText = "no";
                }

                writer.write(responseText);
                break;

            case 6:
                mainCategoryId = request.getParameter("mainCategoryId");
                categoryList = maintainableMgr.getParentIdAndName(mainCategoryId);
                responseText = "";

                for (int i = 0; i < categoryList.size(); i++) {
                    wbo = (WebBusinessObject) categoryList.get(i);
                    unitId = (String) wbo.getAttribute("id");
                    unitName = (String) wbo.getAttribute("unitName");

                    responseText += unitId + "<subelement>" + unitName;
                    if (i < categoryList.size() - 1) {
                        responseText += "<element>";
                    }
                }
                writer.write(responseText);
                break;

            case 7:
                 unitId = request.getParameter("unitId");
                 WebBusinessObject equipmentWBO = (WebBusinessObject) maintainableMgr.getOnSingleKey(unitId);
                 ProjectMgr projectMgr = ProjectMgr.getInstance();
                   try{
                        WebBusinessObject projectWbo =null ;
                        String loc = equipmentWBO.getAttribute("site").toString();
                        if(!loc.equals("NON")){
                        projectWbo =  (WebBusinessObject) projectMgr.getOnSingleKey(loc);
                        if(projectWbo.getAttribute("mainProjId").equals("0")){
                        writer.write(projectWbo.getAttribute("projectName").toString());
                         }else{
                            Vector parentSite = projectMgr.getOnArbitraryKey(projectWbo.getAttribute("mainProjId").toString(), "key");
                            // String parentSiteAndBra=projectWbo.getAttribute("projectName").toString()+" / "+((WebBusinessObject)parentSite.get(0)).getAttribute("projectName");
                            writer.write(projectWbo.getAttribute("projectName").toString()+" الرئيسى : "+((WebBusinessObject)parentSite.get(0)).getAttribute("projectName").toString());
                          }}else{
                            writer.write("\u063A\u064A\u0631 \u0645\u062A\u0627\u062D");
                          }}catch(Exception e){
                            writer.write("\u063A\u064A\u0631 \u0645\u062A\u0627\u062D");
                          }

                break;

            case 8:
                String type = request.getParameter("type");
                String typeCode = request.getParameter("typeCode");
                boolean typeCodeFound = false;

                if(type.equals("dep")) {
                    typeCodeFound = erpDistNamesMgr.getDepartmentsByCodeFromERP(typeCode);

                } else if(type.equals("store")){
                    typeCodeFound = erpDistNamesMgr.getStoresByCodeFromERP(typeCode);

                }

                if (typeCodeFound) {
                    response.getWriter().write("1");
                } else {
                    response.getWriter().write("0");
                }
                break;
                
            case 9:
                String url = request.getParameter("url");
                response.getWriter().write(URLUtils.getTrueUrl(url));
                break;
            
            case 10:

                wbo = new WebBusinessObject();
                
                WebBusinessObject loggedUser = 
                        (WebBusinessObject) session.getAttribute("loggedUser");
                
                int userLastTotalTicketsCount = 
                        (Integer) loggedUser.getAttribute("userTotalTicketsCount");
                
                int userCurrentTotalTicketsCount = 
                        totalTicketsMgr.getUserTotalTicketsCount(
                        (String) loggedUser.getAttribute("userId"));
                                
                if(userCurrentTotalTicketsCount > userLastTotalTicketsCount) {
                    wbo.setAttribute("userHasNewTickets", true);
                    
                } else {
                    wbo.setAttribute("userHasNewTickets", false);
                    
                }
                
                writer.write(Tools.getJSONObjectAsString(wbo));
                break;
                
            case 11:
                String seletedTab = request.getParameter("seletedTab");
                String forPage = request.getParameter("forPage");
                securityUser.getSelectedTab().put(forPage, seletedTab);
                break;
                
            default:
                logger.error("no oreration found ...");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }

    @Override
    protected int getOpCode(String opName) {
        if (opName.equalsIgnoreCase("isSchemaFound")) {
            return 1;
        } else if (opName.equalsIgnoreCase("getImage")) {
            return 2;
        } else if (opName.equalsIgnoreCase("getItemForm")) {
            return 3;
        } else if (opName.equalsIgnoreCase("IgnoreDBError")) {
            return 4;
        } else if(opName.equalsIgnoreCase("saveDistributionParts")) {
            return 5;
        } else if(opName.equalsIgnoreCase("getBrand")) {
            return 6;
        } else if (opName.equalsIgnoreCase("getBranchForEquipment")) {
            return 7;
        } else if(opName.equalsIgnoreCase("checkTypeCode")) {
            return 8;
        } else if(opName.equalsIgnoreCase("checkUrl")) {
            return 9;
        } else if(opName.equalsIgnoreCase("userHasNewTickets")) {
            return 10;
        } else if(opName.equalsIgnoreCase("setSeletedTab")) {
            return 11;
        }
        return 0;
    }
}
