package com.maintenance.servlets;

import com.clients.db_access.ClientLocationMgr;
import com.docviewer.servlets.DocViewerFileRenamePolicy;
import com.maintenance.common.ParseSideMenu;
import com.maintenance.common.Store;
import com.maintenance.common.Tools;
import com.maintenance.db_access.StoreMgr;
import com.silkworm.Exceptions.IncorrectFileType;
import com.silkworm.Exceptions.NoUserInSessionException;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.common.MetaDataMgr;
import com.silkworm.servlets.MultipartRequest;
import com.silkworm.util.FileIO;
import com.tracker.db_access.ProjectMgr;
import java.io.*;
import java.util.Vector;

import javax.servlet.*;
import javax.servlet.http.*;
import com.tracker.servlets.TrackerBaseServlet;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

//import com.maintenance.db_access.ItemMgr;

public class StoreServlet extends TrackerBaseServlet{
    protected MultipartRequest mpr = null;
    
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
    
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }
    
    public void destroy() {
        
    }
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        super.processRequest(request,response);
        HttpSession session = request.getSession();
        WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
        
        switch(operation) {
            case 1:
                servedPage = "/docs/Adminstration/new_store.jsp";
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 2:
                servedPage = "/docs/Adminstration/new_store.jsp";
                StoreMgr storeMgr = StoreMgr.getInstance();
                storeMgr.cashData();
                try {
                    if(!storeMgr.getDoubleName(request.getParameter("storeName"))) {
                        if(storeMgr.saveObject(request))
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
                servedPage = "/docs/Adminstration/store_list.jsp";
                storeMgr = StoreMgr.getInstance();
                storeMgr.cashData();
                Vector stores = storeMgr.getCashedTable();
                
                request.setAttribute("data", stores);
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 4:
                storeMgr = StoreMgr.getInstance();
                String storeID = request.getParameter("storeID");
                WebBusinessObject store = storeMgr.getOnSingleKey(storeID);
                request.setAttribute("store", store);
                servedPage = "/docs/Adminstration/view_store.jsp";
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 5:
                storeMgr = StoreMgr.getInstance();
                storeID = request.getParameter("storeID");
                store = storeMgr.getOnSingleKey(storeID);
                request.setAttribute("store", store);
                servedPage = "/docs/Adminstration/update_store.jsp";
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 6:
                storeMgr = StoreMgr.getInstance();
                storeID = request.getParameter("storeID");
                
                try {
                    if(!storeMgr.getDoubleNameforUpdate(storeID,request.getParameter("storeName"))) {
                        if(storeMgr.updateStore(request))
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
                
                storeMgr.cashData();
                store = storeMgr.getOnSingleKey(storeID);
                request.setAttribute("store", store);
                servedPage = "/docs/Adminstration/update_store.jsp";
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                
                break;
                
            case 7:
                String storeName = request.getParameter("storeName");
                storeID = request.getParameter("storeID");
                
                servedPage = "/docs/Adminstration/confirm_delstore.jsp";
                
                request.setAttribute("storeName",storeName);
                request.setAttribute("storeID",storeID);
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
                
                
            case 8:
                storeID = request.getParameter("storeID");
                storeMgr = StoreMgr.getInstance();
                if(!storeMgr.deleteOnSingleKey(storeID)) {
                    servedPage="/docs/Adminstration/cant_delete_store.jsp";
                    request.setAttribute("servlet", "StoreServlet");
                    request.setAttribute("list", "ListStores");
                    request.setAttribute("type", "Store");
                    request.setAttribute("name", request.getParameter("storeName"));
                    request.setAttribute("page",servedPage);
                } else {
                    storeMgr = storeMgr.getInstance();
                    storeMgr.cashData();
                    stores = storeMgr.getCashedTable();
                    servedPage = "/docs/Adminstration/store_list.jsp";
                    
                    request.setAttribute("data", stores);
                    request.setAttribute("page",servedPage);
                }
                this.forwardToServedPage(request, response);
                break;
                
            case 9:
//                String categoryName = request.getParameter("categoryName");
//                categoryId = request.getParameter("categoryId");
//
//                servedPage = "/docs/Adminstration/confirm_delCat.jsp";
//
//                request.setAttribute("categoryName",categoryName);
//                request.setAttribute("categoryId",categoryId);
//                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 10:
//                Vector Cats = categoryMgr.getCashedTable();
//                categoryMgr.deleteOnSingleKey(request.getParameter("categoryId"));
//                categoryMgr.cashData();
//
//                Cats = categoryMgr.getCashedTable();
//                servedPage = "/docs/Adminstration/Category_List.jsp";
//
//                request.setAttribute("data", Cats);
//                request.setAttribute("page",servedPage);
//
                this.forwardToServedPage(request, response);
                
                break;
                
            case 11:
////                 issueId = request.getParameter(IssueConstants.ISSUEID);
////                 issueTitle = request.getParameter(IssueConstants.ISSUETITLE);
////                WebBusinessObject item = new WebBusinessObject();
//                servedPage = "/docs/Adminstration/new_Items.jsp";
//                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 12:
//                System.out.println("op code is " + operation);
//                loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
//                String userHome = (String) loggedUser.getAttribute("userHome");
//                String imageDirPath =   getServletContext().getRealPath("/images");
//                String userImageDir =  imageDirPath + "/" + userHome;
//                String randome = UniqueIDGen.getNextID();
//                int len = randome.length();
//                String randFileName = new String("ran" +  randome.substring(5,len) + ".jpeg");
//                String RIPath = userImageDir + "/" + randFileName;
//
//                categoryName = request.getParameter("categoryName");
//                String getCategoryId =categoryMgr.getCategoryId(categoryName);
//
//                String itemCode = request.getParameter("itemCode");
//                String itemUnit = request.getParameter("itemUnit");
//                String itemUnitPrice = request.getParameter("itemUnitPrice");
//                String itemDscrptn = request.getParameter("itemDscrptn");
//                String storeID = request.getParameter("storeID");
//
//                WebBusinessObject item = new WebBusinessObject();
//                //begin new
//                String itemID = request.getParameter("itemID");
//                //end
//                item.setAttribute("itemID", itemID);
//                item.setAttribute("categoryName",categoryName);
//                item.setAttribute("getCategoryId",getCategoryId);
//                item.setAttribute("itemCode",itemCode);
//                item.setAttribute("itemUnit",itemUnit);
//                item.setAttribute("itemUnitPrice",itemUnitPrice);
//                item.setAttribute("itemDscrptn",itemDscrptn);
//                item.setAttribute("storeID", storeID);
////                category.setAttribute("catDesc",Description);
//
//                servedPage = "/docs/Adminstration/new_Items.jsp";
//                try {
//                    if(itemMgr.saveObject(item,session))
//                        request.setAttribute("Status" , "Ok");
//                    else
//                        request.setAttribute("Status", "No");
//
//                } catch (NoUserInSessionException noUser) {
//                    System.out.println("Place Servlet: save place " + noUser);
//                }
//                //
//                String imageName = request.getParameter("imageName");
//                if(imageName != null){
//                    File usrDir = new File(imageName);
//                    String[] usrDirContents = usrDir.list();
//                    DocViewerFileRenamePolicy ourPolicy = new DocViewerFileRenamePolicy();
//
//                    String fileExtension = request.getParameter("fileExtension");
//                    FileMgr fileMgr = FileMgr.getInstance();
//                    WebBusinessObject fileDescriptor = fileMgr.getObjectFromCash(fileExtension);
//                    String metaType = (String) fileDescriptor.getAttribute("metaType");
//
//                    ourPolicy.setDesiredFileExt(fileExtension);
//
//                    File newFile = new File(imageName);
//
//                    if(newFile.exists()) {
//
//                        usrDir = new File(imageName);
//                        usrDirContents = usrDir.list();
//
//                        String docImageFilePath =  imageName;
//
//                        FileIO.copyFile(docImageFilePath,userImageDir + "\\" + ourPolicy.getFileName());
//
//
//                        String docType=request.getParameter("docType");
//                        ItemDocMgr itemDocMgr = ItemDocMgr.getInstance();
//                        boolean result = itemDocMgr.saveDocument(request, session,docImageFilePath);
//                    }
//                }
//                //
//                //request.setAttribute("data", issuesList);
//                //request.setAttribute("status", "Unassigned");
//                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 13:
////                Vector categories=new Vector();
//                categoryMgr.cashData();
//                categories = categoryMgr.getAllCategory();
//                System.out.println("sa ----------------- ");
//                servedPage = "/docs/Adminstration/Item_By_Category_List.jsp";
//
//                request.setAttribute("data", categories);
//                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 14:
//
//                Vector  Totalitems =new Vector();
//                categoryId=request.getParameter("categoryId");
//                itemMgr.cashData();
//
//                Totalitems = itemMgr.getAllItems(categoryId);
//                System.out.println("sa ----------------- ");
//                servedPage = "/docs/Adminstration/Items_List.jsp";
//
//                request.setAttribute("data", Totalitems);
//                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 15:
//                //
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
                this.forwardToServedPage(request, response);
                
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
                this.forwardToServedPage(request, response);
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
//                if(itemMgr.updateItem(item)){
//
//                    request.setAttribute("status", "Ok");
//                }
//                item = itemMgr.getOnSingleKey(request.getParameter("itemID"));
//                request.setAttribute("item", item);
//                request.setAttribute("categoryId",getCategoryId);
//                request.setAttribute("itemID",itemID);
//                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
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
                this.forwardToServedPage(request, response);
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
                this.forwardToServedPage(request, response);
                
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
                this.forwardToServedPage(request, response);
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
                this.forwardToServedPage(request, response);
                break;
                
            case 22:
//                servedPage = "/docs/Adminstration/new_unit.jsp";
//                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 23:
//                ItemUnitMgr itemUnitMgr = ItemUnitMgr.getInstance();
//                try {
//                    if(itemUnitMgr.saveObject(request))
//                        request.setAttribute("Status" , "Ok");
//                    else
//                        request.setAttribute("Status", "No");
//                } catch (SQLException ex) {
//                    ex.printStackTrace();
//                }
//                servedPage = "/docs/Adminstration/new_unit.jsp";
//                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 24:
//                itemUnitMgr = ItemUnitMgr.getInstance();
//                itemUnitMgr.cashData();
//                Vector units = itemUnitMgr.getCashedTable();
//                servedPage = "/docs/Adminstration/unit_list.jsp";
//
//                request.setAttribute("data", units);
//                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 25:
//                itemUnitMgr = ItemUnitMgr.getInstance();
//                servedPage = "/docs/Adminstration/view_unit.jsp";
//                String unitID = request.getParameter("unitID");
//
//                WebBusinessObject unit = itemUnitMgr.getOnSingleKey(unitID);
//                request.setAttribute("unit",unit);
//                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 26:
//                itemUnitMgr = ItemUnitMgr.getInstance();
//                servedPage = "/docs/Adminstration/update_unit.jsp";
//                unitID = request.getParameter("unitID");
//                unit = itemUnitMgr.getOnSingleKey(unitID);
//                request.setAttribute("unit",unit);
//                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 27:
//                itemUnitMgr = ItemUnitMgr.getInstance();
//                servedPage = "/docs/Adminstration/update_unit.jsp";
//                unitID = request.getParameter("unitID");
//                if(itemUnitMgr.updateUnit(request))
//                    request.setAttribute("Status" , "Ok");
//                else
//                    request.setAttribute("Status", "No");
//                unit = itemUnitMgr.getOnSingleKey(unitID);
//                request.setAttribute("unit",unit);
//                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
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
                this.forwardToServedPage(request, response);
                break;
                
            case 29:
//                unitID = request.getParameter("unitID");
//                itemUnitMgr = ItemUnitMgr.getInstance();
//                if(!itemUnitMgr.deleteOnSingleKey(unitID)) {
//                    servedPage="/docs/Adminstration/cant_delete.jsp";
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
                this.forwardToServedPage(request, response);
                
                break;
                
            case 30:
                servedPage = "/docs/Adminstration/store_excel.jsp";
                
                request.setAttribute("page",servedPage);
                
                this.forwardToServedPage(request, response);
                break;
                
            case 31:
                servedPage = "/docs/Adminstration/store_excel.jsp";
                
                Vector savedStores = new Vector();
                Vector unsavedStores = new Vector();
                
                storeMgr = StoreMgr.getInstance();
                
                loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                
                String userHome = (String) loggedUser.getAttribute("userHome");
                String imageDirPath =   getServletContext().getRealPath("/images");
                String userImageDir =  imageDirPath + "/" + userHome;
                String userBackendHome = web_inf_path + "/usr/" + userHome + "/";
                
                DocViewerFileRenamePolicy ourPolicy = new DocViewerFileRenamePolicy();
                ourPolicy.setDesiredFileExt("xls");
                
                File oldFile = new File(userBackendHome + ourPolicy.getFileName());
                oldFile.delete();
                
                try {
                    mpr = new MultipartRequest(request,userBackendHome,(5 * 1024 * 1024),"UTF-8",ourPolicy);
                } catch(IncorrectFileType e) {
                    System.out.println("Incorrect file type == "+e.getMessage());
                }
                
                File newFile = new File(userBackendHome + ourPolicy.getFileName());
                String docFilePath =  userBackendHome + ourPolicy.getFileName();
                
                if(newFile.exists()) {
                    FileIO.copyFile(docFilePath,userImageDir + "\\" + ourPolicy.getFileName());
                    
                    try{
                        //Defualt Headers
                        String[] headers = {"Store Name", "Store Number", "Location", "Responsible Employee ID", "Telephone"};
                        
                        FileInputStream source = new FileInputStream(docFilePath);
                        HSSFWorkbook workbook = new HSSFWorkbook(source);
                        for(int i=0; i<workbook.getNumberOfSheets(); i++){
                            HSSFSheet sheet = workbook.getSheetAt(i);
                            
                            if(sheet.getPhysicalNumberOfRows() > 0){
                                if(storeMgr.checkExcelHeader(headers, sheet) == false){
                                    request.setAttribute("Status", "Error");
                                    break;
                                } else {
                                    servedPage = "/docs/Adminstration/stores_saving_report.jsp";
                                    
                                    for(int j=sheet.getFirstRowNum()+1; j<=sheet.getLastRowNum();j++){
                                        HSSFRow row = sheet.getRow(j);
                                        
                                        Vector rowData = storeMgr.createExcelData(row);
                                        
                                        if(storeMgr.saveExcelObject(request, rowData)){
                                            savedStores.addElement(rowData);
                                        } else {
                                            unsavedStores.addElement(rowData);
                                        }
                                    }
                                    
                                    request.setAttribute("savedData", savedStores);
                                    request.setAttribute("unsavedData", unsavedStores);
                                    
                                    System.out.println("Saved Stores Size = "+savedStores.size());
                                    System.out.println("Un Saved Stores Size = "+unsavedStores.size());
                                }
                            }
                        }
                    } catch(IOException ioex){
                        System.out.println("IO Exception "+ioex.getMessage());
                    }
                }
                
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 32:
                
                WebBusinessObject userWbo=new WebBusinessObject();
                MetaDataMgr metaMgr=MetaDataMgr.getInstance();
                ParseSideMenu parseSideMenu=new ParseSideMenu();
                
                userWbo=(WebBusinessObject)session.getAttribute("loggedUser");
                String projectId=userWbo.getAttribute("projectID").toString();
                String storeId=userWbo.getAttribute("storeId").toString();
                storeName=userWbo.getAttribute("storeName").toString();
                String userType=userWbo.getAttribute("userType").toString();
                
                if(storeId.equalsIgnoreCase("noStore")) {
                    request.setAttribute("noStore","yes");
                }else{
                    
                    //open Jar File
                    metaMgr.setMetaData("xfile.jar");
                    
                    Vector storesVec=parseSideMenu.getSiteStores(projectId);
                    Store defultStore=new Store(storeId,storeName,"1");
                    
                    metaMgr.closeDataSource();
                    
                    /************** End of get Site Stores  ***********/
                    
                    request.setAttribute("stores",storesVec);
                    request.setAttribute("defultStore",defultStore);
                    request.setAttribute("projectId",projectId);
                    request.setAttribute("noStore","no");
                    
                }
                
                servedPage="/docs/Adminstration/changeSiteStore.jsp";
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                
                break;
                
            case 33:
                
                userWbo=new WebBusinessObject();
                userWbo=(WebBusinessObject)session.getAttribute("loggedUser");
                
                String storeData[]=request.getParameter("storeId").split("!#");
                storeId=storeData[0];
                storeName=storeData[1];
                projectId=request.getParameter("projectId");
                
                //open Jar File
                metaMgr=MetaDataMgr.getInstance();
                metaMgr.setMetaData("xfile.jar");
                parseSideMenu=new ParseSideMenu();
                
                if(storeId.equalsIgnoreCase("noStore")) {
                    request.setAttribute("noStore","yes");
                }else{
                    
                    Vector storesVec=parseSideMenu.getSiteStores(projectId);
                    
                    metaMgr.closeDataSource();
                    
                    /************** End of get Site Stores  ***********/
                    
                    Store defultStore=new Store(storeId,storeName,"1");
                    
                    if(defultStore!=null){
                        userWbo.setAttribute("storeId",defultStore.id);
                        userWbo.setAttribute("storeName",defultStore.name);
                    }
                    
                    session.removeAttribute("loggedUser");
                    session.setAttribute("loggedUser",userWbo);
                    
                    request.setAttribute("stores",storesVec);
                    request.setAttribute("defultStore",defultStore);
                    request.setAttribute("projectId",projectId);
                    request.setAttribute("noStore","no");
                    
                    WebBusinessObject tempWbo=(WebBusinessObject)session.getAttribute("loggedUser");
                    String temp=tempWbo.getAttribute("storeId").toString();
                    
                    
                    if(defultStore.id.equalsIgnoreCase(temp))
                        request.setAttribute("status","ok");
                    else
                        request.setAttribute("status","fail");
                    
                }
                servedPage="/docs/Adminstration/changeSiteStore.jsp";
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                
                break;
            case 34:
                ProjectMgr projectMgr = ProjectMgr.getInstance();
                storeMgr = StoreMgr.getInstance();
                
                if(request.getParameter("getType") != null && request.getParameter("getType").equals("1")){
                    ArrayList<WebBusinessObject> spareTyp = new ArrayList<WebBusinessObject>();
                    
                    String strID = request.getParameter("strID");

                    try {
                        spareTyp = storeMgr.getSpareTypesStore(strID);
                    } catch (Exception ex) {
                        Logger.getLogger(StoreServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    
                    out = response.getWriter();
                    out.write(Tools.getJSONArrayAsString(spareTyp));
                } else if(request.getParameter("getSpr") != null && request.getParameter("getSpr").equals("1")){
                    ArrayList<WebBusinessObject> sprPrt = new ArrayList<WebBusinessObject>();
                    
                    String strID = request.getParameter("strID");
                    String typID = request.getParameter("typID");
                    
                    if(typID != null && !typID.isEmpty()){
                        try {
                            sprPrt = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKey(typID, "key2"));
                        } catch (Exception ex) {
                            Logger.getLogger(StoreServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    } else {
                        try {
                            sprPrt = storeMgr.getAllSpareStore(strID);
                        } catch (Exception ex) {
                            Logger.getLogger(StoreServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }
                    
                    out = response.getWriter();
                    out.write(Tools.getJSONArrayAsString(sprPrt));
                } else if(request.getParameter("addTypStr") != null && request.getParameter("addTypStr").equals("1")){
                    String strID = request.getParameter("strIDPP");
                    String[] typIDs = (request.getParameter("typIDs").toString()).split(",");
                    loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                    String usrId = (String) loggedUser.getAttribute("userId");
                    WebBusinessObject flag = new WebBusinessObject();
                    String flagStr = "false";
                    
                    for(int index=0; index<typIDs.length; index++){
                        if(storeMgr.addSpareTypesStore(strID, typIDs[index], usrId)){
                            flagStr = "true";
                        } else {
                            flagStr = "false";
                        }
                    }
                    
                    flag.setAttribute("flag", flagStr);
                    out = response.getWriter();
                    out.write(Tools.getJSONObjectAsString(flag));
                } else if(request.getParameter("getTyps") != null && request.getParameter("getTyps").equals("1")){
                    ArrayList<WebBusinessObject> spareTyps = new ArrayList<WebBusinessObject>();
                    
                    String strID = request.getParameter("strID");

                    try {
                        spareTyps = storeMgr.getNotSpareTypesStore(strID);
                    } catch (Exception ex) {
                        Logger.getLogger(StoreServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    
                    out = response.getWriter();
                    out.write(Tools.getJSONArrayAsString(spareTyps));
                }else {
                    servedPage = "/docs/store/storesContent.jsp";
                    
                    ArrayList<WebBusinessObject> strLst = new ArrayList<WebBusinessObject>();
                    try {
                        strLst = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKey("warehouse", "key4"));
                    } catch (Exception ex) {
                        Logger.getLogger(StoreServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    
                    request.setAttribute("strLst", strLst);
                    request.setAttribute("page", servedPage);

                    this.forwardToServedPage(request, response);
               }
                break;
                
            case 35:
                servedPage = "/docs/client/my_client_locations.jsp";
                String clientID = request.getParameter("clientID");
                ClientLocationMgr clientLocationMgr=ClientLocationMgr.getInstance();
                
                try {
                    request.setAttribute("locationsList", new ArrayList<>(clientLocationMgr.getOnArbitraryKeyOracle(clientID,"key1")));
                } catch (Exception ex) {
                    request.setAttribute("locationsList", new ArrayList<>());
                }
                request.setAttribute("clientID", clientID);
                this.forward(servedPage, request, response);
                
                
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
        return "Store Servlet";
    }
    
    protected int getOpCode(String opName) {
        if(opName.indexOf("GetStoreForm") == 0)
            return 1;
        
        if(opName.indexOf("SaveStore") == 0)
            return 2;
        
        if(opName.equals("ListStores"))
            return 3;
        
        if(opName.equals("ViewStore"))
            return 4;
        
        if(opName.equals("GetUpdateStoreForm"))
            return 5;
        
        if(opName.equals("UpdateStore"))
            return 6;
        
        if(opName.equals("ConfirmStoreDelete"))
            return 7;
        
        if(opName.equals("DeleteStore"))
            return 8;
        
//        if(opName.equals("ConfirmDeleteCategory"))
//            return 9;
//
//        if(opName.equals("Delete"))
//            return 10;
//        if(opName.equals("GetItembyCategory"))
//            return 11;
//        if(opName.equals("SavetembyCategory"))
//            return 12;
//        if(opName.equals("ListItembyCategory"))
//            return 13;
//        if(opName.equals("ViewItems"))
//            return 14;
//        if(opName.equals("ShowItem"))
//            return 15;
//        if(opName.equals("GetUpdateItem"))
//            return 16;
//        if(opName.equals("UpdateItem"))
//            return 17;
//        if(opName.equals("ConfirmDeleteItem"))
//            return 18;
//
//        if(opName.equals("DeleteItem"))
//            return 19;
//
//        if(opName.equals("EquipmentItemsReport"))
//            return 20;
//
//        if(opName.equals("SupplierItemsReport"))
//            return 21;
//
//        if(opName.equals("GetUnitForm"))
//            return 22;
//
//        if(opName.equals("SaveUnit"))
//            return 23;
//
//        if(opName.equals("ListUnits"))
//            return 24;
//
//        if(opName.equals("ViewUnit"))
//            return 25;
//
//        if(opName.equals("GetUpdateUnitForm"))
//            return 26;
//
//        if(opName.equals("UpdateUnit"))
//            return 27;
//
//        if(opName.equals("ConfirmUnitDelete"))
//            return 28;
//
//        if(opName.equals("DeleteUnit"))
//            return 29;
        
        if(opName.equals("importExcelStore"))
            return 30;
        
        if(opName.equals("saveImportedStore"))
            return 31;
        if(opName.equals("changeSiteStoreForm"))
            return 32;
        if(opName.equals("changeSiteStore"))
            return 33;
        if(opName.equals("storeContent"))
            return 34;
        
        if(opName.equals("getMyClientLocations"))
            return 35;
        
        return 0;
    }
}