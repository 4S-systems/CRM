package com.maintenance.servlets;

import com.contractor.db_access.MaintainableMgr;
import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.silkworm.business_objects.WebBusinessObject;
import com.tracker.servlets.TrackerBaseServlet;
import com.maintenance.db_access.*;
//import com.tracker.business_objects.ExcelCreator;
import com.tracker.db_access.IssueMgr;
import java.sql.SQLException;
import java.util.ArrayList;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;

public class WorkEquipServlet extends TrackerBaseServlet {

    MaintainableMgr maintainableMgr =  MaintainableMgr.getInstance();
    WorkPlaceMgr workPlaceMgr = WorkPlaceMgr.getInstance();
    WorkEquipMgr workEquipMgr = WorkEquipMgr.getInstance();
    IssueMgr issueMgr = IssueMgr.getInstance();
//    ExcelCreator excelCreator;
    HSSFWorkbook workbook;

    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }

    public void destroy() {

    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException {
        super.processRequest(request, response);
        HttpSession session = request.getSession();

        switch (operation) {
            case 1:
                servedPage = "/docs/WorkEquip/new_equip_work.jsp";
                        String schType="none";

                        WebBusinessObject unitWbo = null;
                        String unitName = new String();
                        String unitCatID = new String();
                        Vector eqpsVec = new Vector();
                        ArrayList placeArray = new ArrayList();
                        String place = null;

                        placeArray = workPlaceMgr.getAllWorkPlace();

                        if(request.getParameter("place") != null){
                            place = (String) request.getParameter("place");
                        }else{
                            if(placeArray.size() > 0)
                                place =(String) ((WebBusinessObject)placeArray.get(0)).getAttribute("name");
                        }

                        try {

                            eqpsVec = maintainableMgr.getOnArbitraryDoubleKey("1","key3","0","key5");
                            if(request.getParameter("unit") != null){
                                if(request.getParameter("unit").equalsIgnoreCase("non")){
                                    if(eqpsVec.size() > 0 ){
                                        unitWbo = (WebBusinessObject) eqpsVec.elementAt(0);
                                    }
                                } else {
                                    unitWbo = maintainableMgr.getOnSingleKey(request.getParameter("unit").toString());
                                }
                            }else{
                                    if(eqpsVec.size() > 0 ){
                                        unitWbo = (WebBusinessObject) eqpsVec.elementAt(0);
                                    }
                            }

                            unitName = unitWbo.getAttribute("unitName").toString();
                            unitCatID = unitWbo.getAttribute("parentId").toString();
                        } catch (SQLException ex) {
                            ex.printStackTrace();
                        } catch (Exception ex) {
                            ex.printStackTrace();
                        }
                        ArrayList eqpsArray=new ArrayList();
                        for(int i=0;i<eqpsVec.size();i++){
                            eqpsArray.add(eqpsVec.get(i));
                        }
                        request.setAttribute("equipments", eqpsArray);
                        request.setAttribute("jobOrder",(String) request.getParameter("jobOrder"));
                        request.setAttribute("selectedUnitName", unitName);
                        request.setAttribute("itemDate", (String) request.getParameter("itemDate"));
                        request.setAttribute("helpDate", (String) request.getParameter("helpDate"));
                        request.setAttribute("failure", (String) request.getParameter("failure"));
                        request.setAttribute("callType", (String) request.getParameter("callType"));
                        request.setAttribute("checkJobOrder", (String) request.getParameter("checkJobOrder"));
                        request.setAttribute("place", place);
                        request.setAttribute("places", placeArray);
                        request.setAttribute("page",servedPage);
                        this.forwardToServedPage(request, response);
                break;
            case 2:
                  WebBusinessObject wbo = new WebBusinessObject();
                  String insertJobOrder;

                  // get templete data
                 String unitId = (String) request.getParameter("unit");
                 String placeId = (String) request.getParameter("place");
                 String helpDate = (String) request.getParameter("helpDate");
                 String callType = (String) request.getParameter("callType");
                 String failure = (String) request.getParameter("failure");

                  // set templete data in wbo
                  wbo.setAttribute("unitId", unitId);
                  wbo.setAttribute("placeId", placeId);
                  wbo.setAttribute("helpDate", helpDate);
                  wbo.setAttribute("callType", callType);
                  wbo.setAttribute("failure", failure);

                  String jobOrder = (String) request.getParameter("jobOrder");
                  String temp = (String) request.getParameter("checkJobOrder");
                  if(temp != null) insertJobOrder = "full";
                  else{
                      insertJobOrder = "custom";
                      jobOrder = "";
                  }

                  if((jobOrder.length() > 0 && jobOrder.contains("/") && insertJobOrder.equalsIgnoreCase("full"))){
                          int indexSlash = jobOrder.indexOf("/");
                          int length = jobOrder.length();
                          String businessId = jobOrder.substring(0, indexSlash);
                          String businessIdByDate = jobOrder.substring(indexSlash + 1, length);

                          Vector vecJobOrder = new Vector();
                          try{
                              vecJobOrder = issueMgr.getOnArbitraryDoubleKey(businessId, "key4", businessIdByDate, "key9");
                          }catch(Exception ex){
                              logger.error(ex.getMessage());
                          }

                          if(vecJobOrder.size() > 0){
                              String jobOrderId = ((WebBusinessObject) vecJobOrder.get(0)).getAttribute("id").toString();
                              String itemDate = (String) request.getParameter("itemDate");                             
                              wbo.setAttribute("jobOrderId", jobOrderId);                      
                              wbo.setAttribute("itemDate", itemDate);


                              if(workEquipMgr.saveObject(wbo, insertJobOrder)){
                                  shipBack(request, response, "savedCompleted");
                              }else{
                                  shipBack(request, response, "error");
                              }
                          }else{
                              shipBack(request, response, "errorJobOrder");
                          }
                  }else if(insertJobOrder.equalsIgnoreCase("custom")){
                              if(workEquipMgr.saveObject(wbo, insertJobOrder)){
                                  shipBack(request, response, "savedCompleted");
                              }else{
                                  shipBack(request, response, "error");
                              }
                  }else{
                     shipBack(request, response, "errorJobOrder");
                  }
                break;
            case 3:
                 servedPage = "/docs/WorkEquip/list_equip_work.jsp";
                 //get all Work Equip.....
                 ArrayList allWorkEquip = workEquipMgr.getAllWorkEquip();
                 // fill vecWorkEquipDetails by unitName ,Work Place and jobOrderNo On Form (x/xx/xxxx)
                 ArrayList arrWorkEquipDetails = new ArrayList();
                 WebBusinessObject wboTemp,wboJobOrder;
                 Iterator it = allWorkEquip.iterator();
                 String temp2,tempJobOrder;
                 while(it.hasNext()){
                     wboTemp = (WebBusinessObject) it.next();
                     wbo = new WebBusinessObject();
                     
                     temp =(String) maintainableMgr.getOnSingleKey((String) wboTemp.getAttribute("equipId")).getAttribute("unitName");
                     wbo.setAttribute("unitName", temp);
                     
                     temp = (String) workPlaceMgr.getOnSingleKey((String) wboTemp.getAttribute("workEquipPlaceId")).getAttribute("name");
                     wbo.setAttribute("place", temp);

                     tempJobOrder = (String) wboTemp.getAttribute("jobOrder");
                     if(tempJobOrder != null){
                         wboJobOrder = issueMgr.getOnSingleKey(tempJobOrder);
                         temp =(String) wboJobOrder.getAttribute("businessID");
                         temp2 = (String) wboJobOrder.getAttribute("businessIDbyDate");
                         wbo.setAttribute("jobOrder", temp + "/" + temp2);
                     }
                     arrWorkEquipDetails.add(wbo);
                 }
                 request.setAttribute("details", arrWorkEquipDetails);
                 request.setAttribute("allWorkEquip", allWorkEquip);
                 request.setAttribute("page", servedPage);
                 this.forward(servedPage, request, response);
                break;
            case 4:
                servedPage = "/docs/WorkEquip/new_work_place.jsp";
                request.setAttribute("name", (String) request.getParameter("name"));
                request.setAttribute("desc", (String) request.getParameter("desc"));
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 5:
                String placeName = (String) request.getParameter("name");
                String placeDesc = (String) request.getParameter("desc");
                if(!workPlaceMgr.workPlaceNameExsit(placeName)){
                    wbo = new WebBusinessObject();
                    wbo.setAttribute("name", placeName);
                    wbo.setAttribute("desc", placeDesc);
                    if(workPlaceMgr.saveWorkPlace(wbo)){
                        shipBackToWorkPlace(request, response, "saved");
                    }else{
                        request.setAttribute("new", "new");
                        shipBackToWorkPlace(request, response, "error");
                    }
                }else{
                    shipBackToWorkPlace(request, response, "errorName");
                }
                break;
            case 6:
                servedPage = "/docs/WorkEquip/list_work_place.jsp";
                ArrayList workPlaceList = workPlaceMgr.getAllWorkPlace();
                request.setAttribute("workPlaceList", workPlaceList);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 7:
                servedPage = "/docs/WorkEquip/view_work_place.jsp";
                String id = (String) request.getParameter("id");
                wbo = workPlaceMgr.getOnSingleKey(id);
                request.setAttribute("workPlace", wbo);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 8:
                servedPage = "/docs/WorkEquip/update_work_place.jsp";
                id = (String) request.getParameter("id");
                wbo = workPlaceMgr.getOnSingleKey(id);
                request.setAttribute("workPlace", wbo);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 9:
                id = (String) request.getParameter("id");
                String oldName = (String) request.getParameter("oldName");
                String newName = (String) request.getParameter("name");
                String note = (String) request.getParameter("desc");
                if(!workPlaceMgr.workPlaceNameExsit(newName) || (oldName == newName)){
                    wbo = new WebBusinessObject();
                    wbo.setAttribute("name", newName);
                    wbo.setAttribute("desc", note);
                    if(workPlaceMgr.updateWorkPlace(wbo, id)){
                        shipBackToListWorkPlace(request, response);
                    }else{
                        request.setAttribute("message", "error");
                        servedPage = "/WorkEquipServlet?op=getUpdateForm";
                        this.forward(servedPage, request, response);
                    }
                }else{
                    request.setAttribute("message", "errorName");
                    servedPage = "/WorkEquipServlet?op=getUpdateForm";
                    this.forward(servedPage, request, response);
                }
                break;
            case 10:
                servedPage = "/docs/WorkEquip/confirm_delete_work_place.jsp";
                id = (String) request.getParameter("id");
                wbo = workPlaceMgr.getOnSingleKey(id);
                request.setAttribute("workPlace", wbo);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 11:
                id = (String) request.getParameter("id");
                workPlaceMgr.deleteWorkPlace(id);
                shipBackToListWorkPlace(request, response);
                break;

            case 12:
//                excelCreator = new ExcelCreator();
//                String filename = request.getParameter("filename");
//                Vector data = (Vector) session.getAttribute("data");
//                String[] headers = (String[]) session.getAttribute("headers");
//                String[] attributeType = (String[]) session.getAttribute("attributeType");
//                String[] attribute = (String[]) session.getAttribute("attribute");
//
//                workbook = excelCreator.createExcelFile(headers, attribute, attributeType, data, 0);
//                response.setHeader("Content-Disposition", "attachment; filename=\""+ filename);
//                workbook.write(response.getOutputStream());
//
//                response.getOutputStream().flush();
//                response.getOutputStream().close();
//                break;
                
            default:
                logger.info("No operation was matched");
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
        if (opName.equalsIgnoreCase("getWorkEquipForm"))
            return 1;
        else if(opName.equalsIgnoreCase("saveWorkEquip"))
            return 2;
        else if(opName.equalsIgnoreCase("listWorkEquip"))
            return 3;
        else if(opName.equalsIgnoreCase("getWorkPlaceForm"))
            return 4;
        else if(opName.equalsIgnoreCase("saveWorkPlace"))
            return 5;
        else if(opName.equalsIgnoreCase("listWorkPlace"))
            return 6;
        else if(opName.equalsIgnoreCase("viewWorkPlace"))
            return 7;
        else if(opName.equalsIgnoreCase("getUpdateForm"))
            return 8;
        else if(opName.equalsIgnoreCase("updateWorkPlace"))
            return 9;
        else if(opName.equalsIgnoreCase("confirmDeleteWorkPlace"))
            return 10;
        else if(opName.equalsIgnoreCase("deleteWorkPlace"))
            return 11;
        else if(opName.equalsIgnoreCase("extractToExcel"))
            return 12;
        return 0;
    }

    private void shipBack(HttpServletRequest request, HttpServletResponse response, String message){
        servedPage = "/WorkEquipServlet?op=getWorkEquipForm";
        request.setAttribute("message", message);
        this.forward(servedPage, request, response);
    }

    private void shipBackToWorkPlace(HttpServletRequest request, HttpServletResponse response, String message){
        servedPage = "/WorkEquipServlet?op=getWorkPlaceForm";
        request.setAttribute("message", message);
        this.forward(servedPage, request, response);
    }

    private void shipBackToListWorkPlace(HttpServletRequest request, HttpServletResponse response){
        servedPage = "/WorkEquipServlet?op=listWorkPlace";
        this.forward(servedPage, request, response);
    }
}

