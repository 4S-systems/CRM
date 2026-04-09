package com.maintenance.servlets;

import com.docviewer.servlets.DocViewerFileRenamePolicy;

import com.silkworm.Exceptions.IncorrectFileType;
import com.silkworm.Exceptions.NoUserInSessionException;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.servlets.MultipartRequest;
import com.silkworm.util.FileIO;

import com.maintenance.db_access.*;

import java.io.*;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Vector;

import javax.servlet.*;
import javax.servlet.http.*;

import com.tracker.servlets.TrackerBaseServlet;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFHeader;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;

public class LocalStoresItemsServlet extends TrackerBaseServlet{
    //Define Local variables
    LocalStoresItemsMgr localStoresItemsMgr = LocalStoresItemsMgr.getInstance();
    
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
                servedPage = "/docs/Stores/New_Spare_Part.jsp";
                
                WarrantyMgr warrantyMgr=WarrantyMgr.getInstance();
                ArrayList warrantData=warrantyMgr.getCashedTableAsBusObjects();
                request.setAttribute("warrantyData",warrantData);
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 2:
                servedPage = "/docs/Stores/New_Spare_Part.jsp";
                
                try {
                    String code = request.getParameter("itemCode");
                    String name = request.getParameter("itemName");
                    
                    Vector itemCodesVec = localStoresItemsMgr.getOnArbitraryKey(code,"key1");
                    Vector itemNamesVec = localStoresItemsMgr.getOnArbitraryKey(name,"key2");
                    
                    LocalItemsWarrantyMgr localItemsWarrantyMgr=LocalItemsWarrantyMgr.getInstance();
                    
                    if((itemCodesVec == null || itemCodesVec.size() == 0) && (itemNamesVec == null || itemNamesVec.size() == 0)){
                        if(localStoresItemsMgr.saveObject(request)){
                            if(localItemsWarrantyMgr.saveObject(request))
                                request.setAttribute("Status" , "Ok");
                        }else{
                            request.setAttribute("Status", "No");
                        }
                    } else {
                        request.setAttribute("Status", "No");
                    }
                } catch (NoUserInSessionException ex) {
                    logger.error(ex.getMessage());
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }
                
                warrantyMgr=WarrantyMgr.getInstance();
                warrantData=warrantyMgr.getCashedTableAsBusObjects();
                request.setAttribute("warrantyData",warrantData);
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                
                break;
                
            case 3:
                Vector items = new Vector();
                localStoresItemsMgr.cashData();
                items=localStoresItemsMgr.getCashedTable();
                
                servedPage = "/docs/Stores/Items_List.jsp";
                
                request.setAttribute("data", items);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 4:
                String itemId = null;
                servedPage = "/docs/Stores/view_Spare_Part.jsp";
                itemId = request.getParameter("itemId");
                WebBusinessObject wboItems = new WebBusinessObject();
                wboItems = localStoresItemsMgr.getOnSingleKey(itemId);
                request.setAttribute("wboItems", wboItems);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                
                break;
                
            case 5:
                
                servedPage = "/docs/Stores/update_Spare_Part.jsp";
                itemId = request.getParameter("itemId");
                wboItems = new WebBusinessObject();
                wboItems = localStoresItemsMgr.getOnSingleKey(itemId);
                request.setAttribute("wboItems", wboItems);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                
                break;
                
            case 6:
                
                servedPage = "/docs/Stores/spare_part_by_date.jsp";
                itemId = request.getParameter("itemId");
                wboItems = new WebBusinessObject();
                wboItems = localStoresItemsMgr.getOnSingleKey(itemId);
                request.setAttribute("wboItems", wboItems);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                
                break;
                
            case 7:
                LocalStoresHistoryMgr localStoresHistoryMgr = LocalStoresHistoryMgr.getInstance();
                items = new Vector();
                localStoresItemsMgr.cashData();
                items=localStoresHistoryMgr.getListSparePartByDate(request);
                
                servedPage = "/docs/Stores/Items_List_by_Date.jsp";
                
                request.setAttribute("beginDate", request.getParameter("beginDate"));
                request.setAttribute("endDate", request.getParameter("endDate"));
                request.setAttribute("data", items);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 8:
                servedPage = "/docs/Stores/update_quantity_parts.jsp";
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
                
                
            case 9:
                servedPage = "/docs/Stores/update_quantity_parts.jsp";
                
                try {
                    String code = request.getParameter("itemCode");
                    String name = request.getParameter("itemName");
                    String id = request.getParameter("id");
                    Vector itemCodesVec = localStoresItemsMgr.getOnArbitraryKey(code,"key1");
                    Vector itemNamesVec = localStoresItemsMgr.getOnArbitraryKey(name,"key2");
                    
                    // if((itemCodesVec == null || itemCodesVec.size() == 0) && (itemNamesVec == null || itemNamesVec.size() == 0)){
                    if(localStoresItemsMgr.saveNewQuantityItem(request))
                        request.setAttribute("Status" , "Ok");
                    else
                        request.setAttribute("Status", "No");
                    // } else {
                    //    request.setAttribute("Status", "No");
                    //  }
                } catch (NoUserInSessionException ex) {
                    logger.error(ex.getMessage());
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }
                
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                
                break;
                
            case 10:
                localStoresHistoryMgr = LocalStoresHistoryMgr.getInstance();
                items = new Vector();
                itemId = request.getParameter("itemId");
                localStoresItemsMgr.cashData();
                wboItems = localStoresItemsMgr.getOnSingleKey(itemId);
                String itemName = wboItems.getAttribute("itemName").toString();
                try {
                    items=localStoresHistoryMgr.getOnArbitraryKey(itemId,"key1");
                } catch (SQLException ex) {
                    ex.printStackTrace();
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
                
                servedPage = "/docs/Stores/Items_List_by_Date_Details.jsp";
                
                request.setAttribute("beginDate", request.getParameter("beginDate"));
                request.setAttribute("endDate", request.getParameter("endDate"));
                request.setAttribute("itemName", itemName);
                request.setAttribute("data", items);
                request.setAttribute("page", servedPage);
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
        return "Local Stores Items Servlet";
    }
    
    protected int getOpCode(String opName) {
        if(opName.equals("addNewItems"))
            return 1;
        
        if(opName.equals("saveNewItems"))
            return 2;
        if(opName.equals("listItems"))
            return 3;
        if(opName.equals("viewItems"))
            return 4;
        
        if(opName.equals("GetUpdateItems"))
            return 5;
        
        if(opName.equals("ItemsByDate"))
            return 6;
        
        if(opName.equals("ResultItemsByDate"))
            return 7;
        if(opName.equals("updateQuantityItems"))
            return 8;
        if(opName.equals("addQuantityItems"))
            return 9;
        if(opName.equals("DetailsItemsByDate"))
            return 10;
        
        
        return 0;
    }
}