package com.out_ofstore_parts.servlets;

import com.Erp.db_access.CostCentersMgr;
import com.Item_Type.db_access.ItemTypeMgr;
import com.maintenance.common.ParseSideMenu;
import com.maintenance.common.Tools;
import com.out_ofstore_parts.db_access.OutOfStorePartsMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.common.MetaDataMgr;
import com.silkworm.common.SecurityUser;
import com.silkworm.pagination.FilterCondition;
import com.silkworm.pagination.Operations;
import com.tracker.servlets.TrackerBaseServlet;
import java.io.IOException;
import java.sql.SQLException;

import java.util.*;
import javax.servlet.ServletException;
import java.util.logging.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class OutOfStorePartsServlet extends TrackerBaseServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            super.processRequest(request, response);
            HttpSession session = request.getSession();
            SecurityUser securityUser = new SecurityUser();
            securityUser = (SecurityUser) session.getAttribute("securityUser");
            ArrayList tempList = new ArrayList();
            ArrayList categoryList = new ArrayList();
            ItemTypeMgr itemtypeMgr = ItemTypeMgr.getInstance();


            switch (operation) {
                case 1:
                    servedPage = "/docs/out_ofstore_parts/add_Item.jsp";
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 2:
                    servedPage = "/docs/out_ofstore_parts/add_Item.jsp";

                    WebBusinessObject itemWbo = new WebBusinessObject();
                    itemWbo.setAttribute("nameAr", request.getParameter("nameAr"));
                    if (request.getParameter("nameEn").equals("")) {
                        itemWbo.setAttribute("nameEn", "no data");
                    } else {
                        itemWbo.setAttribute("nameEn", request.getParameter("nameEn"));
                    }
                    if (request.getParameter("pageNo").equals("")) {
                        itemWbo.setAttribute("pageNo", "no data");
                    } else {
                        itemWbo.setAttribute("pageNo", request.getParameter("pageNo"));
                    }
                    if (request.getParameter("itemNoPic").equals("")) {
                        itemWbo.setAttribute("itemNoPic", "no data");
                    } else {
                        itemWbo.setAttribute("itemNoPic", request.getParameter("itemNoPic"));
                    }
                    if (request.getParameter("expectedPrice").equals("")) {
                        itemWbo.setAttribute("expectedPrice", "0");
                    } else {
                        itemWbo.setAttribute("expectedPrice", request.getParameter("expectedPrice"));
                    }
                    if (request.getParameter("notes").equals("")) {
                        itemWbo.setAttribute("notes", "no data");
                    } else {
                        itemWbo.setAttribute("notes", request.getParameter("notes"));
                    }
                    itemWbo.setAttribute("manufactoryNo", request.getParameter("codeNo"));
                    itemWbo.setAttribute("storeId", "no data");
                    WebBusinessObject spareWbo = null;
                    OutOfStorePartsMgr outOfStorePartsMgr = OutOfStorePartsMgr.getInstance();
                    HttpSession s = request.getSession();
                    securityUser = new SecurityUser();
                    securityUser = (SecurityUser) s.getAttribute("securityUser");
                    String user = securityUser.getUserId();
                    if (!(outOfStorePartsMgr.saveItem(itemWbo, user))) {
                        request.setAttribute("status", "noSave");
                    } else {
                        request.setAttribute("status", "Save");
                        spareWbo = outOfStorePartsMgr.getItems(request.getParameter("codeNo"));
                        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
                        metaMgr.setMetaData("xfile.jar");
                        ParseSideMenu parseSideMenu = new ParseSideMenu();
                        Vector eqpMenu = new Vector();
                        String mode = (String) request.getSession().getAttribute("currentMode");
                        eqpMenu = parseSideMenu.parseSideMenu(mode, "spare_partsMenu.xml", "");
                        metaMgr.closeDataSource();

                        /* Add ids for links*/
                        Vector linkVec = new Vector();
                        String link = "";

                        Hashtable style = new Hashtable();
                        style = (Hashtable) eqpMenu.get(0);
                        String title = style.get("title").toString();
                        title += "<br>" + spareWbo.getAttribute("nameEn").toString();
                        style.remove("title");
                        style.put("title", title);

                        for (int i = 1; i < eqpMenu.size() - 1; i++) {
                            linkVec = new Vector();
                            link = "";
                            linkVec = (Vector) eqpMenu.get(i);
                            link = (String) linkVec.get(1);
                            link += spareWbo.getAttribute("manufactoryNo").toString();
                            linkVec.remove(1);
                            linkVec.add(link);
                        }
                        Hashtable topMenu = new Hashtable();
                        Vector tempVec = new Vector();
                        topMenu = (Hashtable) request.getSession().getAttribute("topMenu");
                        if (topMenu != null && topMenu.size() > 0) {
                            /* 1- Get the current Side menu
                             * 2- Check Menu Type
                             * 3- insert menu object to top menu accordding to it's type
                             */
                            Vector menuType = new Vector();
                            Vector currentSideMenu = (Vector) request.getSession().getAttribute("sideMenuVec");
                            if (currentSideMenu != null && currentSideMenu.size() > 0) {
                                linkVec = new Vector();
                                // the element # 1 in menu is to view the object
                                linkVec = (Vector) currentSideMenu.get(1);
                                // size-1 becouse the menu type is the last element in vector
                                menuType = (Vector) currentSideMenu.get(currentSideMenu.size() - 1);
                                if (menuType != null && menuType.size() > 0) {
                                    topMenu.put((String) menuType.get(1), linkVec);
                                }
                            }
                            request.getSession().setAttribute("topMenu", topMenu);
                        }
                        request.getSession().setAttribute("sideMenuVec", eqpMenu);
                    }
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 3:
                    servedPage = "/docs/out_ofstore_parts/view_Item.jsp";
                    String Manufactory = (String) request.getParameter("manufactoryNo");
                    outOfStorePartsMgr = OutOfStorePartsMgr.getInstance();
                    spareWbo = outOfStorePartsMgr.getItems(Manufactory);
                    request.setAttribute("spareWbo", spareWbo);

                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 4:
                    servedPage = "/docs/out_ofstore_parts/update_Item.jsp";

                    Manufactory = (String) request.getParameter("manufactoryNo");
                    outOfStorePartsMgr = OutOfStorePartsMgr.getInstance();
                    spareWbo = outOfStorePartsMgr.getItems(Manufactory);
                    request.setAttribute("spareWbo", spareWbo);

                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 5:
                    servedPage = "/docs/out_ofstore_parts/new_part.jsp";

                    String model_id = (String) request.getParameter("model_id");
                    String model_name = (String) request.getParameter("model_name");

                    System.out.println("model" + model_id);
                    itemWbo = new WebBusinessObject();
                    itemWbo.setAttribute("model_id", model_id);
                    itemWbo.setAttribute("nameAr", request.getParameter("nameAr"));
                    if (request.getParameter("nameEn").equals("")) {
                        itemWbo.setAttribute("nameEn", "no data");
                    } else {
                        itemWbo.setAttribute("nameEn", request.getParameter("nameEn"));
                    }
                    if (request.getParameter("pageNo").equals("")) {
                        itemWbo.setAttribute("pageNo", "no data");
                    } else {
                        itemWbo.setAttribute("pageNo", request.getParameter("pageNo"));
                    }
                    if (request.getParameter("itemNoPic").equals("")) {
                        itemWbo.setAttribute("itemNoPic", "no data");
                    } else {
                        itemWbo.setAttribute("itemNoPic", request.getParameter("itemNoPic"));
                    }
                    if (request.getParameter("expectedPrice").equals("")) {
                        itemWbo.setAttribute("expectedPrice", "0");
                    } else {
                        itemWbo.setAttribute("expectedPrice", request.getParameter("expectedPrice"));
                    }
                    if (request.getParameter("notes").equals("")) {
                        itemWbo.setAttribute("notes", "no data");
                    } else {
                        itemWbo.setAttribute("notes", request.getParameter("notes"));
                    }

                    itemWbo.setAttribute("partType", request.getParameter("partType"));
                    itemWbo.setAttribute("manufactoryNo", request.getParameter("codeNo"));
                    itemWbo.setAttribute("storeId", "no data");
                    spareWbo = null;
                    outOfStorePartsMgr = OutOfStorePartsMgr.getInstance();
                    s = request.getSession();
                    securityUser = new SecurityUser();
                    securityUser = (SecurityUser) s.getAttribute("securityUser");
                    user = securityUser.getUserId();
                    if (!(outOfStorePartsMgr.saveItem(itemWbo, user))) {
                        request.setAttribute("status", "noSave");
                    } else {
                        request.setAttribute("status", "Save");
                        spareWbo = outOfStorePartsMgr.getItems(request.getParameter("codeNo"));
                        MetaDataMgr metaMgr = MetaDataMgr.getInstance();

                        //menu
                        metaMgr.setMetaData("xfile.jar");
                        ParseSideMenu parseSideMenu = new ParseSideMenu();
                        Vector eqpMenu = new Vector();
                        String mode = (String) request.getSession().getAttribute("currentMode");
                        eqpMenu = parseSideMenu.parseSideMenu(mode, "spare_partsMenu.xml", "");
                        metaMgr.closeDataSource();

                        /* Add ids for links*/
                        Vector linkVec = new Vector();
                        String link = "";

                        Hashtable style = new Hashtable();
                        style = (Hashtable) eqpMenu.get(0);
                        String title = style.get("title").toString();
                        title += "<br>" + spareWbo.getAttribute("nameEn").toString();
                        style.remove("title");
                        style.put("title", title);

                        for (int i = 1; i < eqpMenu.size() - 1; i++) {
                            linkVec = new Vector();
                            link = "";
                            linkVec = (Vector) eqpMenu.get(i);
                            link = (String) linkVec.get(1);
                            link += spareWbo.getAttribute("manufactoryNo").toString();
                            linkVec.remove(1);
                            linkVec.add(link);
                        }
                        //top menu
                        Hashtable topMenu = new Hashtable();
                        Vector tempVec = new Vector();
                        topMenu = (Hashtable) request.getSession().getAttribute("topMenu");
                        if (topMenu != null && topMenu.size() > 0) {
                            /* 1- Get the current Side menu
                             * 2- Check Menu Type
                             * 3- insert menu object to top menu accordding to it's type
                             */
                            Vector menuType = new Vector();
                            Vector currentSideMenu = (Vector) request.getSession().getAttribute("sideMenuVec");
                            if (currentSideMenu != null && currentSideMenu.size() > 0) {
                                linkVec = new Vector();
                                // the element # 1 in menu is to view the object
                                linkVec = (Vector) currentSideMenu.get(1);
                                // size-1 becouse the menu type is the last element in vector
                                menuType = (Vector) currentSideMenu.get(currentSideMenu.size() - 1);
                                if (menuType != null && menuType.size() > 0) {
                                    topMenu.put((String) menuType.get(1), linkVec);
                                }
                            }
                            request.getSession().setAttribute("topMenu", topMenu);
                        }
                        request.getSession().setAttribute("sideMenuVec", eqpMenu);
                    }
                    request.setAttribute("model_name", model_name);
                    request.setAttribute("model_id", model_id);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);

                    break;
                case 6:
                    itemtypeMgr = ItemTypeMgr.getInstance();
                    String arname = (String) request.getParameter("nameAr");
                    String enname = (String) request.getParameter("nameEn");
                    itemWbo = new WebBusinessObject();
                    itemWbo.setAttribute("arname", arname);
                    itemWbo.setAttribute("enname", enname);
                    if (itemtypeMgr.saveObject(itemWbo)) {
                        request.setAttribute("status", "save");
                    } else {
                        request.setAttribute("status", "noSave");
                    }
                    servedPage = "/docs/out_ofstore_parts/item_type.jsp";
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);


                    break;

                case 7:

                    servedPage = "/docs/out_ofstore_parts/item_type.jsp";
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 8:

                    servedPage = "/docs/out_ofstore_parts/list_item_type.jsp";
                    itemtypeMgr = ItemTypeMgr.getInstance();
                    Vector data = new Vector();
                    data = itemtypeMgr.getCashedTable();
                    request.setAttribute("data", data);
                    request.setAttribute("page", servedPage);

                    this.forwardToServedPage(request, response);
                    break;

                case 9:
                    System.out.println("try to view spare parts");
                    String TypeId = request.getParameter("TypeId");
                    System.out.println(TypeId);
                    servedPage = "/docs/out_ofstore_parts/view_item_type.jsp";
                    itemtypeMgr = ItemTypeMgr.getInstance();
                    WebBusinessObject web = new WebBusinessObject();
                    web = itemtypeMgr.getOnSingleKey(TypeId);
                    request.setAttribute("data", web);
                    request.setAttribute("page", servedPage);

                    this.forwardToServedPage(request, response);
                    break;
                case 10:
                    System.out.println("try to update type Part");
                    TypeId = request.getParameter("TypeId");
                    System.out.println(TypeId);
                    servedPage = "/docs/out_ofstore_parts/update_spare_type.jsp";
                    itemtypeMgr = ItemTypeMgr.getInstance();
                    web = new WebBusinessObject();
                    web = itemtypeMgr.getOnSingleKey(TypeId);
                    request.setAttribute("data", web);
                    request.setAttribute("page", servedPage);

                    this.forwardToServedPage(request, response);
                    break;
                case 11:

                    TypeId = request.getParameter("TypeId");
                    arname = request.getParameter("nameAr");
                    enname = request.getParameter("nameEn");
                    System.out.println(TypeId + arname + enname);
                    web = new WebBusinessObject();
                    web.setAttribute("arname", arname);
                    web.setAttribute("enname", enname);
                    web.setAttribute("id", TypeId);
                    itemtypeMgr = ItemTypeMgr.getInstance();
                    try {
                        if (itemtypeMgr.update(web)) {
                            request.setAttribute("states", "ok");
                        } else {
                            request.setAttribute("states", "no");
                        }
                    } catch (SQLException ex) {
                        Logger.getLogger(OutOfStorePartsServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    servedPage = "docs/out_ofstore_parts/update_spare_type.jsp";
                    web = itemtypeMgr.getOnSingleKey(TypeId);
                    request.setAttribute("data", web);

                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 12:

                    servedPage = "/docs/out_ofstore_parts/list_item.jsp";
                    outOfStorePartsMgr = OutOfStorePartsMgr.getInstance();
                    data = new Vector();
                    data = outOfStorePartsMgr.getCashedTable();
                    request.setAttribute("data", data);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);

                    break;
                case 13:
                    String ItemId = request.getParameter("ItemId");
                    servedPage = "/docs/out_ofstore_parts/View_Spare_Item.jsp";
                    outOfStorePartsMgr = OutOfStorePartsMgr.getInstance();
                    web = new WebBusinessObject();
                    web = outOfStorePartsMgr.getOnSingleKey(ItemId);
                    request.setAttribute("data", web);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 14:
                    ItemId = request.getParameter("ItemId");
                    servedPage = "/docs/out_ofstore_parts/Update_Spare_Item.jsp";
                    outOfStorePartsMgr = OutOfStorePartsMgr.getInstance();
                    web = new WebBusinessObject();
                    web = outOfStorePartsMgr.getOnSingleKey(ItemId);
                    request.setAttribute("data", web);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 15:

                    TypeId = request.getParameter("TypeId");
                    arname = request.getParameter("arname");
                    enname = request.getParameter("enname");
                    String page_no = request.getParameter("page_no");
                    String item_no = request.getParameter("item_no");
                    String manfuactory_no = request.getParameter("manfuactory_no");
                    String expected_price = request.getParameter("expected_price");
                    String comment = request.getParameter("comment");
                    String item_type = request.getParameter("item_type");
                    System.out.println(TypeId + arname + enname);
                    web = new WebBusinessObject();
                    web.setAttribute("arname", arname);
                    web.setAttribute("enname", enname);
                    web.setAttribute("page_no", page_no);
                    web.setAttribute("item_no", item_no);
                    web.setAttribute("manfuactory_no", manfuactory_no);
                    web.setAttribute("expected_price", expected_price);
                    web.setAttribute("comment", comment);
                    web.setAttribute("item_type", item_type);
                    web.setAttribute("id", TypeId);
                    outOfStorePartsMgr = OutOfStorePartsMgr.getInstance();

                    if (outOfStorePartsMgr.update(web)) {
                        request.setAttribute("states", "ok");
                    } else {
                        request.setAttribute("states", "no");
                    }

                    servedPage = "docs/out_ofstore_parts/Update_Spare_Item.jsp";
                    web = outOfStorePartsMgr.getOnSingleKey(TypeId);
                    request.setAttribute("data", web);

                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 16:
                    servedPage = "/docs/out_ofstore_parts/new_spare_part.jsp";

                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 17:


                    servedPage = "/docs/out_ofstore_parts/new_spare_part.jsp";
                    spareWbo = null;
                    outOfStorePartsMgr = OutOfStorePartsMgr.getInstance();
                    s = request.getSession();
                    securityUser = new SecurityUser();
                    securityUser = (SecurityUser) s.getAttribute("securityUser");
                    user = securityUser.getUserId();
                    if (!(outOfStorePartsMgr.saveSpareParts(request, user))) {
                        request.setAttribute("status", "noSave");
                    } else {
                        request.setAttribute("status", "Save");
                        spareWbo = outOfStorePartsMgr.getItems(request.getParameter("codeNo"));
                        MetaDataMgr metaMgr = MetaDataMgr.getInstance();

                        //menu
                        metaMgr.setMetaData("xfile.jar");
                        ParseSideMenu parseSideMenu = new ParseSideMenu();
                        Vector eqpMenu = new Vector();
                        String mode = (String) request.getSession().getAttribute("currentMode");
                        eqpMenu = parseSideMenu.parseSideMenu(mode, "spare_partsMenu.xml", "");
                        metaMgr.closeDataSource();

                        /* Add ids for links*/
                        Vector linkVec = new Vector();
                        String link = "";

                        Hashtable style = new Hashtable();
                        style = (Hashtable) eqpMenu.get(0);
                        String title = style.get("title").toString();
                        title += "<br>" + spareWbo.getAttribute("nameEn").toString();
                        style.remove("title");
                        style.put("title", title);

                        for (int i = 1; i < eqpMenu.size() - 1; i++) {
                            linkVec = new Vector();
                            link = "";
                            linkVec = (Vector) eqpMenu.get(i);
                            link = (String) linkVec.get(1);
                            link += spareWbo.getAttribute("manufactoryNo").toString();
                            linkVec.remove(1);
                            linkVec.add(link);
                        }
                        //top menu
                        Hashtable topMenu = new Hashtable();
                        Vector tempVec = new Vector();
                        topMenu = (Hashtable) request.getSession().getAttribute("topMenu");
                        if (topMenu != null && topMenu.size() > 0) {
                            /* 1- Get the current Side menu
                             * 2- Check Menu Type
                             * 3- insert menu object to top menu accordding to it's type
                             */
                            Vector menuType = new Vector();
                            Vector currentSideMenu = (Vector) request.getSession().getAttribute("sideMenuVec");
                            if (currentSideMenu != null && currentSideMenu.size() > 0) {
                                linkVec = new Vector();
                                // the element # 1 in menu is to view the object
                                linkVec = (Vector) currentSideMenu.get(1);
                                // size-1 becouse the menu type is the last element in vector
                                menuType = (Vector) currentSideMenu.get(currentSideMenu.size() - 1);
                                if (menuType != null && menuType.size() > 0) {
                                    topMenu.put((String) menuType.get(1), linkVec);
                                }
                            }
                            request.getSession().setAttribute("topMenu", topMenu);
                        }
                        request.getSession().setAttribute("sideMenuVec", eqpMenu);
                    }
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 18:
                    servedPage = "/docs/out_ofstore_parts/spare_parts_list.jsp";
                    com.silkworm.pagination.Filter filter = new com.silkworm.pagination.Filter();
                    Vector schedules = new Vector();
                    //String[] sitesAll = request.getParameterValues("site");
                    //String sites_all = request.getParameter("site");//Tools.concatenation(sitesAll, ",");
                    filter = Tools.getPaginationInfo(request, response);

                    List<FilterCondition> conditions = filter.getConditions();

                    // add conditions
                    String[] fieldNames = request.getParameterValues("fieldName");
                    String[] fieldValues = request.getParameterValues("fieldValue");
                    for (int i = 0; i < fieldNames.length; i++) {
                        if (fieldNames[i].equals("NAME_AR")) {

                            String field_value = new String("");
                            field_value = Tools.getRealChar((String) fieldValues[i]);
                            conditions.add(new FilterCondition("NAME_AR", field_value, Operations.LIKE));
                            filter.setConditions(conditions);
                            break;
                        } else if (fieldNames[i].equals("NAME_EN")) {

                            String field_value = new String("");
                            field_value = Tools.getRealChar((String) fieldValues[i]);
                            conditions.add(new FilterCondition("NAME_EN", field_value, Operations.LIKE));
                            filter.setConditions(conditions);
                            break;
                        }

                    }
                    outOfStorePartsMgr = OutOfStorePartsMgr.getInstance();
                    List<WebBusinessObject> list = new ArrayList<WebBusinessObject>(0);

                    //grab scheduleList list
                    try {
                        list = outOfStorePartsMgr.paginationEntityByOR(filter, "");
                    } catch (Exception e) {
                        System.out.println(e);
                    }
                    String selectionType = request.getParameter("selectionType");

                    if (selectionType == null) {
                        selectionType = "single";
                    }


                    String formName = (String) request.getParameter("formName");

                    if (formName == null) {
                        formName = "";
                    }

                    request.setAttribute("selectionType", selectionType);
                    request.setAttribute("filter", filter);
                    request.setAttribute("formName", formName);
                    request.setAttribute("list", list);
                    this.forward(servedPage, request, response);
                    break;
            }
        } catch (Exception ex) {
            logger.error(ex.getMessage());
        }

    }

    protected int getOpCode(String opName) {
        if (opName.equals("GetItemForm")) {
            return 1;
        }
        if (opName.equals("saveItem")) {
            return 2;
        }
        if (opName.equals("viewItem")) {
            return 3;
        }
        if (opName.equals("updateItem")) {
            return 4;
        }
        if (opName.equals("savemodel")) {
            return 5;
        }
        if (opName.equals("saveItemType")) {
            return 6;
        }

        if (opName.equalsIgnoreCase("newPartType")) {
            return 7;
        }
        if (opName.equalsIgnoreCase("ViewParts")) {
            return 8;
        }
        if (opName.equalsIgnoreCase("ViewType")) {
            return 9;
        }
        if (opName.equalsIgnoreCase("UpdateType")) {
            return 10;
        }
        if (opName.equalsIgnoreCase("confirmUpdate")) {
            return 11;
        }
        if (opName.equalsIgnoreCase("showingSpareParts")) {
            return 12;

        }
        if (opName.equalsIgnoreCase("ViewItem")) {
            return 13;
        }

        if (opName.equalsIgnoreCase("UpdateItem")) {
            return 14;
        }
        if (opName.equalsIgnoreCase("confirmUpdateItem")) {
            return 15;
        }

        if (opName.equalsIgnoreCase("confirmUpdateItem")) {
            return 15;
        }

        if (opName.equalsIgnoreCase("newSparePart")) {
            return 16;
        }

        if (opName.equalsIgnoreCase("saveSparePart")) {
            return 17;
        }
        if (opName.equalsIgnoreCase("listSpareParts")) {
            return 18;
        }

        return 0;
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>
}
