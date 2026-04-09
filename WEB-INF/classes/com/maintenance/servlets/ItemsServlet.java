package com.maintenance.servlets;

import com.docviewer.servlets.DocViewerFileRenamePolicy;
import com.silkworm.db_access.FileMgr;
import com.silkworm.servlets.MultipartRequest;
import com.silkworm.util.FileIO;
import java.io.*;
import java.util.*;
import java.sql.SQLException;

import javax.servlet.*;
import javax.servlet.http.*;

import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.Exceptions.*;

import com.tracker.common.*;
import com.tracker.servlets.TrackerBaseServlet;

import com.maintenance.db_access.*;

import com.contractor.db_access.MaintainableMgr;
import com.silkworm.persistence.relational.UniqueIDGen;
import java.awt.image.BufferedImage;
import javax.imageio.ImageIO;
//import com.maintenance.db_access.ItemMgr;
public class ItemsServlet extends TrackerBaseServlet {

    MaintainableMgr unit = MaintainableMgr.getInstance();
    ItemCatsMgr itemCatsMgr = ItemCatsMgr.getInstance();
    CategoryMgr categoryMgr = CategoryMgr.getInstance();
    ItemMgr itemMgr = ItemMgr.getInstance();
    String op = null;
    String filterName = null;
    String filterValue = null;
    String categoryId = null;
    Vector unitsList = null;
    ArrayList unitArr;
    ArrayList itemCategory;
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
        WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");

        switch (operation) {
            case 1:
                servedPage = "/docs/Adminstration/new_equip_item.jsp";

                unitArr = new ArrayList();
                itemCategory = new ArrayList();

                unit.cashData();
                categoryMgr.cashData();
                unitArr = unit.getCashedTableAsBusObjects();
                itemCategory = categoryMgr.getCashedTableAsBusObjects();

                request.setAttribute("units", unitArr);
                request.setAttribute("category", itemCategory);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 2:
                servedPage = "/docs/Adminstration/new_equip_item.jsp";
                WebBusinessObject itemWbo = new WebBusinessObject();
                String[] items = request.getParameterValues("items");
                itemWbo.setAttribute("equipmentID", request.getParameter("equipmentID").toString());
                itemWbo.setAttribute("categoryID", request.getParameter("categoryID").toString());

                try {
                    if (itemCatsMgr.saveObject(itemWbo, session, items)) {
                        request.setAttribute("Status", "Ok");
                    } else {
                        request.setAttribute("Status", "No");
                    }
                } catch (NoUserInSessionException noUser) {
                    logger.error("Items Servlet: save Project " + noUser);
                } catch (SQLException ex) {
                    logger.error("SQL Exception in save item servlet " + ex.getMessage());
                }

                unitArr = new ArrayList();
                itemCategory = new ArrayList();

                unit.cashData();
                categoryMgr.cashData();
                unitArr = unit.getCashedTableAsBusObjects();
                itemCategory = categoryMgr.getCashedTableAsBusObjects();

                request.setAttribute("units", unitArr);
                request.setAttribute("category", itemCategory);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 3:
                String CatName = request.getParameter("categoryName");
                String Description = request.getParameter("catDsc");

                WebBusinessObject category = new WebBusinessObject();

                category.setAttribute("CatName", CatName);
                category.setAttribute("catDesc", Description);

                servedPage = "/docs/Adminstration/new_Category.jsp";
                try {
                    if (!categoryMgr.getDoubleName(request.getParameter("categoryName"))) {
                        if (categoryMgr.saveObject(category, session)) {
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
                //request.setAttribute("data", issuesList);
                //request.setAttribute("status", "Unassigned");
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 4:
                String issueId = request.getParameter(IssueConstants.ISSUEID);
                String issueTitle = request.getParameter(IssueConstants.ISSUETITLE);

                servedPage = "/docs/Adminstration/new_Category.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 5:
                Vector categories = new Vector();
                categoryMgr.cashData();
                categories = categoryMgr.getAllCategory();
                servedPage = "/docs/Adminstration/Category_List.jsp";

                request.setAttribute("data", categories);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 6:

                servedPage = "/docs/Adminstration/view_Category.jsp";
                categoryId = request.getParameter("categoryId");

                category = categoryMgr.getOnSingleKey(categoryId);
                request.setAttribute("category", category);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);

                break;

            case 7:
                categoryId = request.getParameter("categoryId");
                category = categoryMgr.getOnSingleKey(categoryId);

                servedPage = "/docs/Adminstration/update_category.jsp";

                request.setAttribute("category", category);

                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;


            case 8:
                String categoryId = request.getParameter("categoryId").toString();
                servedPage = "/docs/Adminstration/update_category.jsp";

                category = new WebBusinessObject();
                category.setAttribute("categoryName", request.getParameter("categoryName"));
                category.setAttribute("catDsc", request.getParameter("catDsc"));
                category.setAttribute("categoryId", request.getParameter("categoryId"));

                try {
                    if (!categoryMgr.getDoubleNameforUpdate(categoryId, request.getParameter("categoryName"))) {
                        if (categoryMgr.updateCategory(category)) {
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

                category = categoryMgr.getOnSingleKey(request.getParameter("categoryId"));
                request.setAttribute("category", category);

                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 9:
                String categoryName = request.getParameter("categoryName");
                categoryId = request.getParameter("categoryId");

                servedPage = "/docs/Adminstration/confirm_delCat.jsp";

                request.setAttribute("categoryName", categoryName);
                request.setAttribute("categoryId", categoryId);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 10:
                Vector Cats = categoryMgr.getCashedTable();
                categoryMgr.deleteOnSingleKey(request.getParameter("categoryId"));
                categoryMgr.cashData();

                Cats = categoryMgr.getCashedTable();
                servedPage = "/docs/Adminstration/Category_List.jsp";

                request.setAttribute("data", Cats);
                request.setAttribute("page", servedPage);

                this.forwardToServedPage(request, response);

                break;

            case 11:
//                 issueId = request.getParameter(IssueConstants.ISSUEID);
//                 issueTitle = request.getParameter(IssueConstants.ISSUETITLE);
//                WebBusinessObject item = new WebBusinessObject();
                servedPage = "/docs/Adminstration/new_Items.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 12:
                loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                String userHome = (String) loggedUser.getAttribute("userHome");
                String imageDirPath = getServletContext().getRealPath("/images");
                String userImageDir = imageDirPath + "/" + userHome;
                String randome = UniqueIDGen.getNextID();
                int len = randome.length();
                String randFileName = new String("ran" + randome.substring(5, len) + ".jpeg");
                String RIPath = userImageDir + "/" + randFileName;
                userHome = (String) loggedUser.getAttribute("userHome");
                userImageDir = imageDirPath + "/" + userHome;
                String userBackendHome = web_inf_path + "/usr/" + userHome + "/";
                File usrDir = new File(userBackendHome);
                String[] usrDirContents = usrDir.list();
                DocViewerFileRenamePolicy ourPolicy = new DocViewerFileRenamePolicy();


                ourPolicy.setDesiredFileExt("jpg");

                File oldFile = new File(userBackendHome + ourPolicy.getFileName());
                oldFile.delete();

                try {
                    mpr = new MultipartRequest(request, userBackendHome, (5 * 1024 * 1024), "UTF-8", ourPolicy);

                } catch (IncorrectFileType e) {

                }

                String fileExtension = mpr.getParameter("fileExtension");
                FileMgr fileMgr = FileMgr.getInstance();
                WebBusinessObject fileDescriptor = fileMgr.getObjectFromCash(fileExtension);
                String metaType = (String) fileDescriptor.getAttribute("metaType");

                categoryName = mpr.getParameter("categoryName");
                String getCategoryId = categoryMgr.getCategoryId(categoryName);

                String itemCode = mpr.getParameter("itemCode");
                String itemUnit = mpr.getParameter("itemUnit");
                String itemUnitPrice = mpr.getParameter("itemUnitPrice");
                String itemDscrptn = mpr.getParameter("itemDscrptn");
                String storeID = mpr.getParameter("storeID");
                String imageName = mpr.getParameter("imageName");
                String itemID = mpr.getParameter("itemID");

                WebBusinessObject item = new WebBusinessObject();
                //begin new

                //end
                item.setAttribute("itemID", itemID);
                item.setAttribute("categoryName", categoryName);
                item.setAttribute("getCategoryId", getCategoryId);
                item.setAttribute("itemCode", itemCode);
                item.setAttribute("itemUnit", itemUnit);
                item.setAttribute("itemUnitPrice", itemUnitPrice);
                item.setAttribute("itemDscrptn", itemDscrptn);
                item.setAttribute("storeID", storeID);
//                category.setAttribute("catDesc",Description);

                servedPage = "/docs/Adminstration/new_Items.jsp";

                try {
                    if (!itemMgr.getDoubleName(itemDscrptn)) {

                        if (itemMgr.saveObject(item, session)) {
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
                //

                if (imageName != null) {

                    File newFile = new File(userBackendHome + ourPolicy.getFileName());

                    if (newFile.exists()) {

                        usrDir = new File(userBackendHome);
                        usrDirContents = usrDir.list();

                        String docImageFilePath = userBackendHome + ourPolicy.getFileName();

                        FileIO.copyFile(docImageFilePath, userImageDir + "\\" + ourPolicy.getFileName());

                        String docType = mpr.getParameter("docType");
                        ItemDocMgr itemDocMgr = ItemDocMgr.getInstance();
                        boolean result = itemDocMgr.saveImageDocument(mpr, session, docImageFilePath);
                    }
                }
                //
                //request.setAttribute("data", issuesList);
                //request.setAttribute("status", "Unassigned");
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 13:
//                Vector categories=new Vector();
                categoryMgr.cashData();
                categories = categoryMgr.getAllCategory();
                servedPage = "/docs/Adminstration/Item_By_Category_List.jsp";

                request.setAttribute("data", categories);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 14:

                Vector Totalitems = new Vector();
                categoryId = request.getParameter("categoryId");
                itemMgr.cashData();

                Totalitems = itemMgr.getAllItems(categoryId);
                servedPage = "/docs/Adminstration/Items_List.jsp";

                request.setAttribute("categoryId", categoryId);
                request.setAttribute("data", Totalitems);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 15:
                //
                ItemDocMgr itemDocMgr = ItemDocMgr.getInstance();
                Vector imageList = itemDocMgr.getImagesList(request.getParameter("itemID"));
                Vector imagesPath = new Vector();
                servedPage = "/docs/item_doc_handling/view_images.jsp";
                request.setAttribute("page", servedPage);
                for (int i = 0; i < imageList.size(); i++) {

                    String docID = ((WebBusinessObject) imageList.get(i)).getAttribute("docID").toString();

                    loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                    userHome = (String) loggedUser.getAttribute("userHome");
                    imageDirPath = getServletContext().getRealPath("/images");
                    userImageDir = imageDirPath + "/" + userHome;
                    randome = UniqueIDGen.getNextID();
                    len = randome.length();
                    randFileName = new String("ran" + randome.substring(5, len) + ".jpeg");
                    RIPath = userImageDir + "/" + randFileName;

                    String absPath = "images/" + userHome + "/" + randFileName;

                    File docImage = new File(RIPath);

                    BufferedInputStream gifData = new BufferedInputStream(itemDocMgr.getImage(docID));
                    BufferedImage myImage = ImageIO.read(gifData);
                    ImageIO.write(myImage, "jpeg", docImage);
                    imagesPath.add(absPath);
                }
                request.setAttribute("imagePath", imagesPath);

                //
                itemID = null;
                categoryId = request.getParameter("categoryId");
                servedPage = "/docs/Adminstration/view_Item.jsp";
                itemID = request.getParameter("itemID");

                item = itemMgr.getOnSingleKey(itemID);
                request.setAttribute("categoryId", categoryId);
                request.setAttribute("item", item);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);

                break;

            case 16:
                String itemId = null;

                categoryId = request.getParameter("categoryId");
                itemID = request.getParameter("itemID");
                item = itemMgr.getOnSingleKey(itemID);

                servedPage = "/docs/Adminstration/update_Item.jsp";

                request.setAttribute("categoryId", categoryId);
                request.setAttribute("item", item);
                request.setAttribute("itemID", itemID);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 17:
                itemID = request.getParameter("itemID");
                servedPage = "/docs/Adminstration/update_Item.jsp";
                getCategoryId = categoryMgr.getCategoryId(request.getParameter("categoryName"));
                item = new WebBusinessObject();
                itemDscrptn = request.getParameter("itemDscrptn").toString();
                item.setAttribute("itemCode", request.getParameter("itemCode"));
                item.setAttribute("itemUnit", request.getParameter("itemUnit"));
                item.setAttribute("itemUnitPrice", request.getParameter("itemUnitPrice"));
                item.setAttribute("itemDscrptn", request.getParameter("itemDscrptn"));
                item.setAttribute("categoryName", request.getParameter("categoryName"));

                item.setAttribute("categoryId", getCategoryId);
                item.setAttribute("itemID", request.getParameter("itemID"));
                item.setAttribute("storeID", request.getParameter("storeID"));

                try {
                    if (!itemMgr.getDoubleNameforUpdate(itemID, itemDscrptn)) {
                        if (itemMgr.updateItem(item)) {
                            if (itemMgr.saveObject(item, session)) {
                                request.setAttribute("Status", "Ok");
                            } else {
                                request.setAttribute("Status", "No");
                            }
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

                item = itemMgr.getOnSingleKey(request.getParameter("itemID"));
                request.setAttribute("item", item);
                request.setAttribute("categoryId", getCategoryId);
                request.setAttribute("itemID", itemID);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 18:
                itemID = request.getParameter("itemID");
                String pIndex = request.getParameter("pIndex");
//                categoryName = request.getParameter("categoryName");
                categoryId = request.getParameter("categoryId");

                servedPage = "/docs/Adminstration/confirm_delItem.jsp";
                item = itemMgr.getOnSingleKey(itemID);
                request.setAttribute("categoryId", categoryId);
                request.setAttribute("pIndex", pIndex);
                request.setAttribute("item", item);
//                request.setAttribute("categoryName",categoryName);
                request.setAttribute("itemID", itemID);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 19:
                Vector Items = itemMgr.getCashedTable();
                categoryId = request.getParameter("categoryId");
                itemMgr.deleteOnSingleKey(request.getParameter("itemID"));
                itemMgr.cashData();

                Items = itemMgr.getCashedTable();
                Totalitems = itemMgr.getAllItems(categoryId);
                servedPage = "/docs/Adminstration/Items_List.jsp";
                request.setAttribute("data", Totalitems);
                request.setAttribute("page", servedPage);
                request.setAttribute("categoryId", categoryId);
                this.forwardToServedPage(request, response);

                break;

            case 20:
                servedPage = "/docs/reports/equip_items.jsp";

                unitArr = new ArrayList();
                itemCategory = new ArrayList();

                unit.cashData();
                categoryMgr.cashData();
                unitArr = unit.getCashedTableAsBusObjects();
                itemCategory = categoryMgr.getCashedTableAsBusObjects();

                request.setAttribute("units", unitArr);
                request.setAttribute("category", itemCategory);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 21:
                servedPage = "/docs/reports/supplier_items.jsp";

                ArrayList supplierArr = new ArrayList();
                itemCategory = new ArrayList();

                SupplierMgr supplierMgr = SupplierMgr.getInstance();
                supplierMgr.cashData();
                categoryMgr.cashData();
                supplierArr = supplierMgr.getCashedTableAsBusObjects();
                itemCategory = categoryMgr.getCashedTableAsBusObjects();

                request.setAttribute("supplierArr", supplierArr);
                request.setAttribute("category", itemCategory);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 22:
                servedPage = "/docs/Adminstration/new_unit.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 23:
                ItemUnitMgr itemUnitMgr = ItemUnitMgr.getInstance();
                try {
                    if (!itemUnitMgr.getDoubleName(request.getParameter("unitName"))) {
                        if (itemUnitMgr.saveObject(request)) {
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
                servedPage = "/docs/Adminstration/new_unit.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 24:
                itemUnitMgr = ItemUnitMgr.getInstance();
                itemUnitMgr.cashData();
                Vector units = itemUnitMgr.getCashedTable();
                servedPage = "/docs/Adminstration/unit_list.jsp";

                request.setAttribute("data", units);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 25:
                itemUnitMgr = ItemUnitMgr.getInstance();
                servedPage = "/docs/Adminstration/view_unit.jsp";
                String unitID = request.getParameter("unitID");

                WebBusinessObject unitWbo = itemUnitMgr.getOnSingleKey(unitID);
                request.setAttribute("unit", unitWbo);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 26:
                itemUnitMgr = ItemUnitMgr.getInstance();
                servedPage = "/docs/Adminstration/update_unit.jsp";
                unitID = request.getParameter("unitID");
                unitWbo = itemUnitMgr.getOnSingleKey(unitID);
                request.setAttribute("unit", unitWbo);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 27:
                itemUnitMgr = ItemUnitMgr.getInstance();
                servedPage = "/docs/Adminstration/update_unit.jsp";
                unitID = request.getParameter("unitID");

                try {
                    if (!itemUnitMgr.getDoubleNameforUpdate(unitID, request.getParameter("unitName"))) {
                        if (itemUnitMgr.updateUnit(request)) {
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


                unitWbo = itemUnitMgr.getOnSingleKey(unitID);
                request.setAttribute("unit", unitWbo);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 28:
                String unitName = request.getParameter("unitName");
                unitID = request.getParameter("unitID");

                servedPage = "/docs/Adminstration/confirm_delunit.jsp";

                request.setAttribute("unitName", unitName);
                request.setAttribute("unitID", unitID);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 29:
                unitID = request.getParameter("unitID");
                itemUnitMgr = ItemUnitMgr.getInstance();
                if (!itemUnitMgr.deleteOnSingleKey(unitID)) {
                    servedPage = "/docs/Adminstration/cant_delete_store.jsp";
                    request.setAttribute("servlet", "ItemsServlet");
                    request.setAttribute("list", "ListUnits");
                    request.setAttribute("type", "Unit");
                    request.setAttribute("name", request.getParameter("unitName"));
                    request.setAttribute("page", servedPage);
                } else {
                    itemUnitMgr = ItemUnitMgr.getInstance();
                    itemUnitMgr.cashData();
                    units = itemUnitMgr.getCashedTable();
                    servedPage = "/docs/Adminstration/unit_list.jsp";

                    request.setAttribute("data", units);
                    request.setAttribute("page", servedPage);
                }
                this.forwardToServedPage(request, response);

                break;

            case 30:
                servedPage = "/docs/Adminstration/new_category_item.jsp";

                unitArr = new ArrayList();
                itemCategory = new ArrayList();

                unit.cashData();
                categoryMgr.cashData();
                unitArr = unit.getCashedTableAsBusObjects();
                itemCategory = categoryMgr.getCashedTableAsBusObjects();

                request.setAttribute("units", unitArr);
                request.setAttribute("category", itemCategory);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 31:
                servedPage = "/docs/Adminstration/new_category_item.jsp";
                ConfigureCategoryMgr configureCategoryMgr = ConfigureCategoryMgr.getInstance();
                itemWbo = new WebBusinessObject();
                items = request.getParameterValues("items");
                itemWbo.setAttribute("equipmentID", request.getParameter("equipmentID").toString());
                itemWbo.setAttribute("categoryID", request.getParameter("categoryID").toString());

                try {
                    if (configureCategoryMgr.saveObject(itemWbo, session, items)) {
                        request.setAttribute("Status", "Ok");
                    } else {
                        request.setAttribute("Status", "No");
                    }
                } catch (NoUserInSessionException noUser) {
                    logger.error("Items Servlet: save Project " + noUser);
                } catch (SQLException ex) {
                    logger.error("SQL Exception in save item servlet " + ex.getMessage());
                }

                unitArr = new ArrayList();
                itemCategory = new ArrayList();

                unit.cashData();
                categoryMgr.cashData();
                unitArr = unit.getCashedTableAsBusObjects();
                itemCategory = categoryMgr.getCashedTableAsBusObjects();

                request.setAttribute("units", unitArr);
                request.setAttribute("category", itemCategory);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 32:
                servedPage = "/docs/reports/equip_category_items.jsp";

                unitArr = new ArrayList();
                itemCategory = new ArrayList();

                unit.cashData();
                categoryMgr.cashData();
                unitArr = unit.getCashedTableAsBusObjects();
                itemCategory = categoryMgr.getCashedTableAsBusObjects();

                request.setAttribute("units", unitArr);
                request.setAttribute("category", itemCategory);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 33:
                servedPage = "/docs/reports/search_item.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 34:
                String key = request.getParameter("key");
                String returnXML = new String("");
                MaintenanceItemMgr maintenanceItemMgr = MaintenanceItemMgr.getInstance();
                if (key != null) {
                    Vector vecTemp = new Vector();
                    try {
                        vecTemp = maintenanceItemMgr.getOnArbitraryKey(key, "key3");
                    } catch (SQLException ex) {
                        logger.error(ex.getMessage());
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }
                    if (vecTemp.size() > 0) {
                        WebBusinessObject wbo = (WebBusinessObject) vecTemp.get(0);
                        String temp = (String) wbo.getAttribute("storeID");
                        StoreMgr storeMgr = StoreMgr.getInstance();
                        WebBusinessObject wboTemp = storeMgr.getOnSingleKey(temp);
                        wbo.setAttribute("storeName", wboTemp.getAttribute("storeName"));

                        temp = (String) wbo.getAttribute("categoryId");
                        CategoryMgr categoryMgr = CategoryMgr.getInstance();
                        wboTemp = categoryMgr.getOnSingleKey(temp);
                        wbo.setAttribute("categoryName", wboTemp.getAttribute("categoryName"));

                        if (wbo != null) {
                            returnXML = wbo.getObjectAsXML();
                        }
                    }
                    response.getWriter().write(returnXML);
                } else {
                    response.setContentType("text/xml");
                    response.setHeader("Cache-Control", "no-cache");
                    response.getWriter().write("?");
                }
                break;

            case 35:
                servedPage = "/docs/Search/item_search.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 36:
                ItemsMgr itemsMgr = ItemsMgr.getInstance();
                Vector itemsList = itemsMgr.getRequiredItemsInRange(request);
                servedPage = "/docs/Search/item_result.jsp";
                request.setAttribute("page", servedPage);
                request.setAttribute("data", itemsList);
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
        return "Search Servlet";
    }

    protected int getOpCode(String opName) {
        if (opName.indexOf("GetItemsForm") == 0) {
            return 1;
        }

        if (opName.indexOf("SaveItem") == 0) {
            return 2;
        }
        if (opName.equals("SaveCategory")) {
            return 3;
        }
        if (opName.equals("ViewCategoryForm")) {
            return 4;
        }
        if (opName.equals("ListCategory")) {
            return 5;
        }

        if (opName.equals("ViewCategory")) {
            return 6;
        }

        if (opName.equals("GetUpdateCategory")) {
            return 7;
        }
        if (opName.equals("UpdateCategory")) {
            return 8;
        }
        if (opName.equals("ConfirmDeleteCategory")) {
            return 9;
        }

        if (opName.equals("Delete")) {
            return 10;
        }
        if (opName.equals("GetItembyCategory")) {
            return 11;
        }
        if (opName.equals("SavetembyCategory")) {
            return 12;
        }
        if (opName.equals("ListItembyCategory")) {
            return 13;
        }
        if (opName.equals("ViewItems")) {
            return 14;
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

        if (opName.indexOf("SearchItem") == 0) {
            return 33;
        }

        if (opName.equals("GetXML")) {
            return 34;
        }

        if (opName.equals("GetItemsSearchForm")) {
            return 35;
        }

        if (opName.equals("ItemsSearchResult")) {
            return 36;
        }

        return 0;
    }
}

