package com.maintenance.servlets;

import com.contractor.db_access.MaintainableMgr;
import com.maintenance.common.DateParser;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.servlets.MultipartRequest;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.tracker.servlets.TrackerBaseServlet;
import com.maintenance.db_access.*;
import com.silkworm.Exceptions.NoUserInSessionException;
import java.util.Calendar;
import java.util.Vector;

public class EqStateTypeServlet extends TrackerBaseServlet {
//    MaintainableMgr unit =  MaintainableMgr.getInstance();
//    ItemCatsMgr itemCatsMgr = ItemCatsMgr.getInstance();
//    CategoryMgr categoryMgr=CategoryMgr.getInstance();
//    ItemMgr itemMgr = ItemMgr.getInstance();
//
//    String op = null;
//    String filterName = null;
//    String filterValue = null;
//    String categoryId=null;
//
//    Vector unitsList = null;
//    ArrayList unitArr;
//    ArrayList itemCategory;
    EqStateTypeMgr eqStateTypeMgr;
    protected MultipartRequest mpr = null;
    
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }
    
    public void destroy() {
        
    }
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        super.processRequest(request, response);
        HttpSession session = request.getSession();
        
        switch (operation) {
            case 1:
                servedPage = "/docs/Adminstration/new_eq_state_type.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 2:
                servedPage = "/docs/Adminstration/new_eq_state_type.jsp";
                WebBusinessObject stateWbo = new WebBusinessObject();
                eqStateTypeMgr = EqStateTypeMgr.getInstance();
                stateWbo.setAttribute("name", request.getParameter("stateName").toString());
                stateWbo.setAttribute("note", request.getParameter("note").toString());
                try {
                    if (!eqStateTypeMgr.getDoubleName(request.getParameter("stateName"))) {
                        if (eqStateTypeMgr.saveObject(stateWbo, session)) {
                            request.setAttribute("Status", "Ok");
                        } else {
                            request.setAttribute("Status", "No");
                        }
                    } else {
                        request.setAttribute("Status", "No");
                        request.setAttribute("name", "Duplicate Name");
                    }
                } catch (NoUserInSessionException ex) {
                    logger.error(ex.getMessage());
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 3:
                String stateID = request.getParameter("stateID");
                eqStateTypeMgr = EqStateTypeMgr.getInstance();
                stateWbo = eqStateTypeMgr.getOnSingleKey(stateID);
                request.setAttribute("state", stateWbo);
                servedPage = "/docs/Adminstration/view_eq_state_type.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 4:
                Vector states = new Vector();
                eqStateTypeMgr = EqStateTypeMgr.getInstance();
                eqStateTypeMgr.cashData();
                states = eqStateTypeMgr.getCashedTable();
                servedPage = "/docs/Adminstration/state_type_list.jsp";
                
                request.setAttribute("data", states);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 5:
                stateID = request.getParameter("stateID");
                eqStateTypeMgr = EqStateTypeMgr.getInstance();
                stateWbo = eqStateTypeMgr.getOnSingleKey(stateID);
                
                servedPage = "/docs/Adminstration/update_eq_state_type.jsp";
                
                request.setAttribute("state", stateWbo);
                
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
                
            case 6:
                servedPage = "/docs/Adminstration/update_eq_state_type.jsp";
                stateID = request.getParameter("stateID");
                stateWbo = new WebBusinessObject();
                stateWbo.setAttribute("name", request.getParameter("stateName"));
                stateWbo.setAttribute("note", request.getParameter("note"));
                stateWbo.setAttribute("id", stateID);
                eqStateTypeMgr = EqStateTypeMgr.getInstance();
                
                try {
                    if (!eqStateTypeMgr.getDoubleNameforUpdate(stateID, request.getParameter("stateName"))) {
                        if (eqStateTypeMgr.updateState(stateWbo)) {
                            request.setAttribute("Status", "Ok");
                        } else {
                            request.setAttribute("Status", "No");
                        }
                    } else {
                        request.setAttribute("Status", "No");
                        request.setAttribute("name", "Duplicate Name");
                    }
                } catch (NoUserInSessionException ex) {
                    logger.error(ex.getMessage());
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }
                
                stateWbo = eqStateTypeMgr.getOnSingleKey(stateID);
                request.setAttribute("state", stateWbo);
                
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 7:
                String stateName = request.getParameter("stateName");
                stateID = request.getParameter("stateID");
                
                servedPage = "/docs/Adminstration/confirm_delStateType.jsp";
                
                request.setAttribute("stateName", stateName);
                request.setAttribute("stateID", stateID);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 8:
                eqStateTypeMgr = EqStateTypeMgr.getInstance();
                eqStateTypeMgr.deleteOnSingleKey(request.getParameter("stateID"));
                eqStateTypeMgr.cashData();
                states = eqStateTypeMgr.getCashedTable();
                servedPage = "/docs/Adminstration/state_type_list.jsp";
                
                request.setAttribute("data", states);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                
                break;
                
            case 9:
                MaintainableMgr maintainableMgr = MaintainableMgr.getInstance();
                Vector categoryTemp = maintainableMgr.getCashedTable();
                Vector category = new Vector();
                for (int i = 0; i < categoryTemp.size(); i++) {
                    WebBusinessObject wbo = (WebBusinessObject) categoryTemp.get(i);
                    if (wbo.getAttribute("isMaintainable").toString().equalsIgnoreCase("1")) {
                        category.add(wbo);
                    }
                }
                servedPage = "/docs/Adminstration/equipment_status_list.jsp";
                
                request.setAttribute("data", category);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 10:
                String currentStatus = request.getParameter("currentStatus");
                
                servedPage = "/docs/Adminstration/change_equipment_status.jsp";
                
                request.setAttribute("page", servedPage);
                request.setAttribute("currentStatus", currentStatus);
                this.forwardToServedPage(request, response);
                break;
                
            case 11:
                servedPage = "/docs/Adminstration/change_equipment_status.jsp";
                
                EquipmentStatusMgr equipmentStatusMgr = EquipmentStatusMgr.getInstance();
                WebBusinessObject wboStatus = new WebBusinessObject();
                
                currentStatus = request.getParameter("currentStatus");
                
                //initialize Status WebBusinessObject
                wboStatus.setAttribute("equipmentID", request.getParameter("equipmentID"));
                wboStatus.setAttribute("stateID", request.getParameter("stateID"));
                wboStatus.setAttribute("beginDate", request.getParameter("beginDate"));
                wboStatus.setAttribute("hour", request.getParameter("h"));
                wboStatus.setAttribute("minute", request.getParameter("m"));
                request.setAttribute("currentStatus", currentStatus);
                if(request.getParameter("note") == null || request.getParameter("note").equalsIgnoreCase("")){
                    wboStatus.setAttribute("note", "No notes");
                } else {
                    wboStatus.setAttribute("note", request.getParameter("note"));
                }
                
                //Compare current status Date and new begin date
                String currentDate = request.getParameter("statusDate");
                String beginDate = request.getParameter("beginDate");
                
//                Calendar currentCal = Calendar.getInstance();
//                Calendar beginCal = Calendar.getInstance();
//
//                DateParser dateParser=new DateParser();
//
//                String currentDatefields[] = currentDate.split("-");
//                String tempDate=currentDate.replaceAll("-","/");
//
//                int cYear=dateParser.getyear(tempDate);
//                int cMonth=dateParser.getMonth(tempDate);
//                int cDay=dateParser.getDay(tempDate);
//
//                currentCal.set(cYear,cMonth ,cDay);
//
////                String beginDatefields[] = beginDate.split("/");
////                int bYear=Integer.parseInt(beginDatefields[2]);
////                int bMonth=Integer.parseInt(beginDatefields[0])-1;
////                int bDay=Integer.parseInt(beginDatefields[1]);
//
//                int bYear=dateParser.getyear(beginDate);
//                int bMonth=dateParser.getMonth(beginDate);
//                int bDay=dateParser.getDay(beginDate);
//
//                beginCal.set(bYear,bMonth,bDay, new Integer(request.getParameter("h")).intValue(), new Integer(request.getParameter("m")).intValue());
//
//                if(beginCal.before(currentCal)) {
//                    if(currentStatus.equals("1")){
//                        request.setAttribute("currentStatus","2");
//                    } else {
//                        request.setAttribute("currentStatus","1");
//                    }
//
//                    request.setAttribute("status", "wrong dates");
//                } else{
                //Save Status
                try {
                    if (equipmentStatusMgr.saveObject(wboStatus, request.getSession())) {
                        request.setAttribute("status", "Ok");
                    } else {
                        if(currentStatus.equals("1")){
                            request.setAttribute("currentStatus","2");
                        } else {
                            request.setAttribute("currentStatus","1");
                        }
                        
                        request.setAttribute("status", "No");
                    }
                } catch (NoUserInSessionException ex) {
                    if(currentStatus.equals("1")){
                        request.setAttribute("currentStatus","2");
                    } else {
                        request.setAttribute("currentStatus","1");
                    }
                    
                    request.setAttribute("status", "No");
                }
//                }
                
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 12:
                String equipmentID = request.getParameter("equipmentID");
                equipmentStatusMgr = EquipmentStatusMgr.getInstance();
                Vector vecStatus = equipmentStatusMgr.getStatusHistory(equipmentID);
                
                servedPage = "/docs/Adminstration/equipment_status_history.jsp";
                request.setAttribute("data", vecStatus);
                request.setAttribute("equipmentID", equipmentID);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 15:
                //
//                ItemDocMgr itemDocMgr = ItemDocMgr.getInstance();
//                Vector imageList = itemDocMgr.getImagesList(request.getParameter("itemID"));
//                Vector imagesPath = new Vector();
//                servedPage = "/docs/item_doc_handling/view_images.jsp";
//                request.setAttribute("page",servedPage);
//                for(int i = 0; i < imageList.size(); i++){
//
//                    String docID = ((WebBusinessObject) imageList.get(i)).getAttribute("docID").toString();
//
//                    loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
//                    userHome = (String) loggedUser.getAttribute("userHome");
//                    imageDirPath =   getServletContext().getRealPath("/images");
//                    userImageDir =  imageDirPath + "/" + userHome;
//                    randome = UniqueIDGen.getNextID();
//                    len = randome.length();
//                    randFileName = new String("ran" +  randome.substring(5,len) + ".jpeg");
//                    RIPath = userImageDir + "/" + randFileName;
//
//                    String absPath = "images/" + userHome + "/" + randFileName;
//
//                    File docImage = new File(RIPath);
//
//                    BufferedInputStream gifData = new BufferedInputStream(itemDocMgr.getImage(docID));
//                    BufferedImage myImage = ImageIO.read(gifData);
//                    ImageIO.write(myImage,"jpeg",docImage);
//                    imagesPath.add(absPath);
//                }
//                request.setAttribute("imagePath", imagesPath);
//
//                //
//                itemID =null;
//                categoryId=request.getParameter("categoryId");
//                servedPage = "/docs/Adminstration/view_Item.jsp";
//                itemID = request.getParameter("itemID");
//
//                item = itemMgr.getOnSingleKey(itemID);
//                request.setAttribute("categoryId",categoryId);
//                request.setAttribute("item",item);
//                request.setAttribute("page",servedPage);
//                this.forwardToServedPage(request, response);
                
                break;
                
            case 16:
//                String itemId=null;
//
//                categoryId = request.getParameter("categoryId");
//                itemID=request.getParameter("itemID");
//                item = itemMgr.getOnSingleKey(itemID);
//
//                servedPage = "/docs/Adminstration/update_Item.jsp";
//
//                request.setAttribute("categoryId",categoryId);
//                request.setAttribute("item",item);
//                request.setAttribute("itemID",itemID);
//                request.setAttribute("page",servedPage);
//                this.forwardToServedPage(request, response);
                break;
                
            case 17:
//                itemID=request.getParameter("itemID");
//                servedPage="/docs/Adminstration/update_Item.jsp";
//                getCategoryId =categoryMgr.getCategoryId(request.getParameter("categoryName"));
//                item = new WebBusinessObject();
//
//                item.setAttribute("itemCode",request.getParameter("itemCode"));
//                item.setAttribute("itemUnit",request.getParameter("itemUnit"));
//                item.setAttribute("itemUnitPrice",request.getParameter("itemUnitPrice"));
//                item.setAttribute("itemDscrptn",request.getParameter("itemDscrptn"));
//                item.setAttribute("categoryName",request.getParameter("categoryName"));
//
//                item.setAttribute("categoryId",getCategoryId);
//                item.setAttribute("itemID",request.getParameter("itemID"));
//                item.setAttribute("storeID", request.getParameter("storeID"));
//                if(itemMgr.updateState(item)){
//
//                    request.setAttribute("status", "Ok");
//                }
//                item = itemMgr.getOnSingleKey(request.getParameter("itemID"));
//                request.setAttribute("item", item);
//                request.setAttribute("categoryId",getCategoryId);
//                request.setAttribute("itemID",itemID);
//                request.setAttribute("page",servedPage);
//                this.forwardToServedPage(request, response);
                break;
                
            case 18:
//                itemID = request.getParameter("itemID");
////                categoryName = request.getParameter("categoryName");
//                categoryId = request.getParameter("categoryId");
//
//                servedPage = "/docs/Adminstration/confirm_delItem.jsp";
//                item = itemMgr.getOnSingleKey(itemID);
//                request.setAttribute("categoryId",categoryId);
//                request.setAttribute("item",item);
////                request.setAttribute("categoryName",categoryName);
//                request.setAttribute("itemID",itemID);
//                request.setAttribute("page",servedPage);
//                this.forwardToServedPage(request, response);
                break;
                
            case 19:
//                Vector Items = itemMgr.getCashedTable();
//                categoryId = request.getParameter("categoryId");
//                itemMgr.deleteOnSingleKey(request.getParameter("itemID"));
//                itemMgr.cashData();
//
//                Items = itemMgr.getCashedTable();
//                Totalitems = itemMgr.getAllItems(categoryId);
//                servedPage = "/docs/Adminstration/Items_List.jsp";
//
//                request.setAttribute("data", Totalitems);
//                request.setAttribute("page",servedPage);
//
//                this.forwardToServedPage(request, response);
                
                break;
                
            case 20:
//                servedPage = "/docs/reports/equip_items.jsp";
//
//                unitArr = new ArrayList();
//                itemCategory = new ArrayList();
//
//                unit.cashData();
//                categoryMgr.cashData();
//                unitArr = unit.getCashedTableAsBusObjects();
//                itemCategory = categoryMgr.getCashedTableAsBusObjects();
//
//                request.setAttribute("units", unitArr);
//                request.setAttribute("category", itemCategory);
//                request.setAttribute("page",servedPage);
//                this.forwardToServedPage(request, response);
                break;
                
            case 21:
//                servedPage = "/docs/reports/supplier_items.jsp";
//
//                ArrayList supplierArr = new ArrayList();
//                itemCategory = new ArrayList();
//
//                SupplierMgr supplierMgr = SupplierMgr.getInstance();
//                supplierMgr.cashData();
//                categoryMgr.cashData();
//                supplierArr = supplierMgr.getCashedTableAsBusObjects();
//                itemCategory = categoryMgr.getCashedTableAsBusObjects();
//
//                request.setAttribute("supplierArr", supplierArr);
//                request.setAttribute("category", itemCategory);
//                request.setAttribute("page",servedPage);
//                this.forwardToServedPage(request, response);
                break;
                
            case 22:
//                servedPage = "/docs/Adminstration/new_unit.jsp";
//                request.setAttribute("page",servedPage);
//                this.forwardToServedPage(request, response);
                break;
                
            case 23:
//                ItemUnitMgr itemUnitMgr = ItemUnitMgr.getInstance();
//                try {
//                    if(itemUnitMgr.saveObject(request))
//                        request.setAttribute("Status" , "Ok");
//                    else
//                        request.setAttribute("Status", "No");
//                } catch (SQLException ex) {
//                    logger.error(ex.getMessage());
//                }
//                servedPage = "/docs/Adminstration/new_unit.jsp";
//                request.setAttribute("page",servedPage);
//                this.forwardToServedPage(request, response);
                break;
                
            case 24:
//                itemUnitMgr = ItemUnitMgr.getInstance();
//                itemUnitMgr.cashData();
//                Vector units = itemUnitMgr.getCashedTable();
//                servedPage = "/docs/Adminstration/unit_list.jsp";
//
//                request.setAttribute("data", units);
//                request.setAttribute("page",servedPage);
//                this.forwardToServedPage(request, response);
                break;
                
            case 25:
//                itemUnitMgr = ItemUnitMgr.getInstance();
//                servedPage = "/docs/Adminstration/view_unit.jsp";
//                String unitID = request.getParameter("unitID");
//
//                WebBusinessObject unitWbo = itemUnitMgr.getOnSingleKey(unitID);
//                request.setAttribute("unit",unitWbo);
//                request.setAttribute("page",servedPage);
//                this.forwardToServedPage(request, response);
                break;
                
            case 26:
//                itemUnitMgr = ItemUnitMgr.getInstance();
//                servedPage = "/docs/Adminstration/update_unit.jsp";
//                unitID = request.getParameter("unitID");
//                unitWbo = itemUnitMgr.getOnSingleKey(unitID);
//                request.setAttribute("unit",unitWbo);
//                request.setAttribute("page",servedPage);
//                this.forwardToServedPage(request, response);
                break;
                
            case 27:
//                itemUnitMgr = ItemUnitMgr.getInstance();
//                servedPage = "/docs/Adminstration/update_unit.jsp";
//                unitID = request.getParameter("unitID");
//                if(itemUnitMgr.updateUnit(request))
//                    request.setAttribute("Status" , "Ok");
//                else
//                    request.setAttribute("Status", "No");
//                unitWbo = itemUnitMgr.getOnSingleKey(unitID);
//                request.setAttribute("unit",unitWbo);
//                request.setAttribute("page",servedPage);
//                this.forwardToServedPage(request, response);
                break;
                
            case 28:
//                String unitName = request.getParameter("unitName");
//                unitID = request.getParameter("unitID");
//
//                servedPage = "/docs/Adminstration/confirm_delunit.jsp";
//
//                request.setAttribute("unitName",unitName);
//                request.setAttribute("unitID",unitID);
//                request.setAttribute("page",servedPage);
//                this.forwardToServedPage(request, response);
                break;
                
            case 29:
//                unitID = request.getParameter("unitID");
//                itemUnitMgr = ItemUnitMgr.getInstance();
//                if(!itemUnitMgr.deleteOnSingleKey(unitID)) {
//                    servedPage="/docs/Adminstration/cant_delete_store.jsp";
//                    request.setAttribute("servlet", "ItemsServlet");
//                    request.setAttribute("list", "ListUnits");
//                    request.setAttribute("type", "Unit");
//                    request.setAttribute("name", request.getParameter("unitName"));
//                    request.setAttribute("page",servedPage);
//                } else {
//                    itemUnitMgr = ItemUnitMgr.getInstance();
//                    itemUnitMgr.cashData();
//                    units = itemUnitMgr.getCashedTable();
//                    servedPage = "/docs/Adminstration/unit_list.jsp";
//
//                    request.setAttribute("data", units);
//                    request.setAttribute("page",servedPage);
//                }
//                this.forwardToServedPage(request, response);
                
                break;
                
            case 30:
//                servedPage = "/docs/Adminstration/new_category_item.jsp";
//
//                unitArr = new ArrayList();
//                itemCategory = new ArrayList();
//
//                unit.cashData();
//                categoryMgr.cashData();
//                unitArr = unit.getCashedTableAsBusObjects();
//                itemCategory = categoryMgr.getCashedTableAsBusObjects();
//
//                request.setAttribute("units", unitArr);
//                request.setAttribute("category", itemCategory);
//                request.setAttribute("page",servedPage);
//                this.forwardToServedPage(request, response);
                break;
                
            case 31:
//                servedPage = "/docs/Adminstration/new_category_item.jsp";
//                ConfigureCategoryMgr configureCategoryMgr = ConfigureCategoryMgr.getInstance();
//                itemWbo = new WebBusinessObject();
//                items = request.getParameterValues("items");
//                itemWbo.setAttribute("equipmentID", request.getParameter("equipmentID").toString());
//                itemWbo.setAttribute("categoryID", request.getParameter("categoryID").toString());
//
//                try {
//                    if(configureCategoryMgr.saveObject(itemWbo, session, items))
//                        request.setAttribute("Status" , "Ok");
//                    else
//                        request.setAttribute("Status", "No");
//                } catch (NoUserInSessionException noUser) {
                
//                } catch(SQLException ex) {
                
//                }
//
//                unitArr = new ArrayList();
//                itemCategory = new ArrayList();
//
//                unit.cashData();
//                categoryMgr.cashData();
//                unitArr = unit.getCashedTableAsBusObjects();
//                itemCategory = categoryMgr.getCashedTableAsBusObjects();
//
//                request.setAttribute("units", unitArr);
//                request.setAttribute("category", itemCategory);
//                request.setAttribute("page",servedPage);
//                this.forwardToServedPage(request, response);
                break;
                
            case 32:
//                servedPage = "/docs/reports/equip_category_items.jsp";
//
//                unitArr = new ArrayList();
//                itemCategory = new ArrayList();
//
//                unit.cashData();
//                categoryMgr.cashData();
//                unitArr = unit.getCashedTableAsBusObjects();
//                itemCategory = categoryMgr.getCashedTableAsBusObjects();
//
//                request.setAttribute("units", unitArr);
//                request.setAttribute("category", itemCategory);
//                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
                
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
        return "EqStateType Servlet";
    }
    
    protected int getOpCode(String opName) {
        if (opName.indexOf("GetEqStateForm") == 0) {
            return 1;
        }
        if (opName.indexOf("SaveState") == 0) {
            return 2;
        }
        if (opName.equals("ViewStateType")) {
            return 3;
        }
        if (opName.equals("ListStates")) {
            return 4;
        }
        if (opName.equals("GetUpdateStateForm")) {
            return 5;
        }
        if (opName.equals("UpdateState")) {
            return 6;
        }
        if (opName.equals("ConfirmStateDelete")) {
            return 7;
        }
        if (opName.equals("DeleteState")) {
            return 8;
        }
        if (opName.equals("ListEquipmentStatus")) {
            return 9;
        }
        if (opName.equals("ChangeStatusForm")) {
            return 10;
        }
        if (opName.equals("SaveStatus")) {
            return 11;
        }
        if (opName.equals("ViewStatusHistory")) {
            return 12;
        }
        
        if (opName.equals("ShowItem")) {
            return 15;
        }
        if (opName.equals("GetUpdateItem")) {
            return 16;
        }
        if (opName.equals("UpdateItem")) {
            return 17;
        }
        if (opName.equals("ConfirmDeleteItem")) {
            return 18;
        }
        
        if (opName.equals("DeleteItem")) {
            return 19;
        }
        
        if (opName.equals("EquipmentItemsReport")) {
            return 20;
        }
        
        if (opName.equals("SupplierItemsReport")) {
            return 21;
        }
        
        if (opName.equals("GetUnitForm")) {
            return 22;
        }
        
        if (opName.equals("SaveUnit")) {
            return 23;
        }
        
        if (opName.equals("ListUnits")) {
            return 24;
        }
        
        if (opName.equals("ViewUnit")) {
            return 25;
        }
        
        if (opName.equals("GetUpdateUnitForm")) {
            return 26;
        }
        
        if (opName.equals("UpdateUnit")) {
            return 27;
        }
        
        if (opName.equals("ConfirmUnitDelete")) {
            return 28;
        }
        
        if (opName.equals("DeleteUnit")) {
            return 29;
        }
        
        if (opName.equals("GetItemCatForm")) {
            return 30;
        }
        
        if (opName.equals("SaveCatItem")) {
            return 31;
        }
        
        if (opName.equals("EquipmentCatItemsReport")) {
            return 32;
        }
        
        return 0;
    }
}

