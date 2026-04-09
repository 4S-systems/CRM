package com.maintenance.servlets;

import com.maintenance.db_access.SupplierItemMgr;
import com.maintenance.db_access.SupplierMgr;
import com.silkworm.Exceptions.NoUserInSessionException;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.common.SecurityUser;
import com.silkworm.logger.db_access.LoggerMgr;
import com.tracker.servlets.TrackerBaseServlet;
import java.io.*;
import java.sql.SQLException;
import java.util.Vector;

import javax.servlet.*;
import javax.servlet.http.*;

public class SupplierServlet extends TrackerBaseServlet {
    SupplierMgr supplierMgr;
    LoggerMgr loggerMgr = LoggerMgr.getInstance();
    SecurityUser securityUser;

    @Override
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        super.processRequest(request,response);
        HttpSession session = request.getSession();
        securityUser = (SecurityUser) session.getAttribute("securityUser");
        
        switch(operation) {
            case 1:
                servedPage = "/docs/Adminstration/new_supplier.jsp";
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 2:
                servedPage = "/docs/Adminstration/new_supplier.jsp";
                supplierMgr = SupplierMgr.getInstance();
                try {
                    if(supplierMgr.saveSupplier(request, session))
                        request.setAttribute("Status" , "Ok");
                    else
                        request.setAttribute("Status", "No");
                    
                } catch (NoUserInSessionException noUser) {
                    System.out.println("Place Servlet: save place " + noUser);
                }
                supplierMgr.cashData();
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 3:
                supplierMgr = SupplierMgr.getInstance();
                //supplierMgr.cashData();
                Vector suppliers = supplierMgr.getCashedTable();
                servedPage = "/docs/Adminstration/supplier_list.jsp";
                
                request.setAttribute("data", suppliers);
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 4:
                servedPage = "/docs/Adminstration/view_supplier.jsp";
                String supplierID = request.getParameter("supplierID");
                supplierMgr = SupplierMgr.getInstance();
                WebBusinessObject supplierWBO = supplierMgr.getOnSingleKey(supplierID);
                request.setAttribute("supplierWBO", supplierWBO);
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 5:
                servedPage = "/docs/Adminstration/update_supplier.jsp";
                supplierID = request.getParameter("supplierID");
                supplierMgr = SupplierMgr.getInstance();
                supplierWBO = supplierMgr.getOnSingleKey(supplierID);
                request.setAttribute("supplierWBO", supplierWBO);
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 6:
                
                servedPage = "/docs/Adminstration/update_supplier.jsp";
                supplierID = request.getParameter("supplierID");
                supplierMgr = SupplierMgr.getInstance();
                try {
                    if(supplierMgr.updateSupplier(request))
                        request.setAttribute("Status" , "Ok");
                    else
                        request.setAttribute("Status", "No");
                    
                } catch (NoUserInSessionException noUser) {
                    System.out.println("Place Servlet: save place " + noUser);
                }
                supplierMgr.cashData();
                supplierWBO = supplierMgr.getOnSingleKey(supplierID);
                request.setAttribute("supplierWBO", supplierWBO);
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 7:
                servedPage = "/docs/Adminstration/new_item_supplier.jsp";
                String itemID = request.getParameter("itemID");
                String categoryId = request.getParameter("categoryId");
                request.setAttribute("categoryId", categoryId);
                request.setAttribute("itemID", itemID);
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 8:
                servedPage = "/docs/Adminstration/new_item_supplier.jsp";
                itemID = request.getParameter("itemID");
                categoryId = request.getParameter("categoryId");
                SupplierItemMgr supplierItemMgr = SupplierItemMgr.getInstance();
                
                try {
                    if(supplierItemMgr.saveSupplierItem(request)){
                        request.setAttribute("Status" , "Ok");
                    }
                } catch (NoUserInSessionException ex) {
                    request.setAttribute("Status" , "No");
                }
                request.setAttribute("categoryId", categoryId);
                request.setAttribute("itemID", itemID);
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
                
                
            case 9:
                supplierItemMgr = SupplierItemMgr.getInstance();
                itemID = request.getParameter("itemID");
                categoryId = request.getParameter("categoryId");
                try {
                    suppliers = supplierItemMgr.getOnArbitraryKey(itemID, "key");
                    request.setAttribute("data", suppliers);
                } catch (SQLException ex) {
                    logger.error(ex.getMessage());
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }
                servedPage = "/docs/Adminstration/item_supplier_list.jsp";
                request.setAttribute("itemID", itemID);
                request.setAttribute("categoryId", categoryId);
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 10:
                itemID = request.getParameter("itemID");
                categoryId = request.getParameter("categoryId");
                supplierID = request.getParameter("supplierID");
                supplierItemMgr = SupplierItemMgr.getInstance();
                Vector vecSupplier = supplierItemMgr.getItemSupplier(itemID, supplierID);
                WebBusinessObject supplierItem = new WebBusinessObject();
                if(vecSupplier.size() > 0){
                    supplierItem = (WebBusinessObject) vecSupplier.elementAt(0);
                }
                servedPage = "/docs/Adminstration/view_item_supplier.jsp";
                request.setAttribute("supplierItem", supplierItem);
                request.setAttribute("itemID", itemID);
                request.setAttribute("categoryId", categoryId);
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                
                break;
                
            case 11:
                itemID = request.getParameter("itemID");
                categoryId = request.getParameter("categoryId");
                supplierID = request.getParameter("supplierID");
                supplierItemMgr = SupplierItemMgr.getInstance();
                vecSupplier = supplierItemMgr.getItemSupplier(itemID, supplierID);
                supplierItem = new WebBusinessObject();
                if(vecSupplier.size() > 0){
                    supplierItem = (WebBusinessObject) vecSupplier.elementAt(0);
                }
                servedPage = "/docs/Adminstration/update_item_supplier.jsp";
                request.setAttribute("supplierItem", supplierItem);
                request.setAttribute("itemID", itemID);
                request.setAttribute("categoryId", categoryId);
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 12:
                itemID = request.getParameter("itemID");
                categoryId = request.getParameter("categoryId");
                supplierID = request.getParameter("supplierID");
                supplierItemMgr = SupplierItemMgr.getInstance();
                
                try {
                    if(supplierItemMgr.updateSupplierItem(request)){
                        request.setAttribute("Status" , "Ok");
                    }
                } catch (NoUserInSessionException ex) {
                    request.setAttribute("Status" , "No");
                }
                vecSupplier = supplierItemMgr.getItemSupplier(itemID, supplierID);
                supplierItem = new WebBusinessObject();
                if(vecSupplier.size() > 0){
                    supplierItem = (WebBusinessObject) vecSupplier.elementAt(0);
                }
                servedPage = "/docs/Adminstration/update_item_supplier.jsp";
                request.setAttribute("supplierItem", supplierItem);
                request.setAttribute("itemID", itemID);
                request.setAttribute("categoryId", categoryId);
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 13:
                itemID = request.getParameter("itemID");
                categoryId = request.getParameter("categoryId");
                supplierID = request.getParameter("supplierID");
                String supplierName = request.getParameter("supplierName");
                servedPage = "/docs/Adminstration/confirm_delSupplierItem.jsp";
                request.setAttribute("itemID", itemID);
                request.setAttribute("supplierID", supplierID);
                request.setAttribute("supplierName", supplierName);
                request.setAttribute("categoryId", categoryId);
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 14:
                supplierItemMgr = SupplierItemMgr.getInstance();
                itemID = request.getParameter("itemID");
                categoryId = request.getParameter("categoryId");
                supplierID = request.getParameter("supplierID");
                try {
                    supplierItemMgr.deleteItemSupplier(itemID, supplierID);
                    suppliers = supplierItemMgr.getOnArbitraryKey(itemID, "key");
                    request.setAttribute("data", suppliers);
                } catch (SQLException ex) {
                    logger.error(ex.getMessage());
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }
                servedPage = "/docs/Adminstration/item_supplier_list.jsp";
                request.setAttribute("itemID", itemID);
                request.setAttribute("supplierID", supplierID);
                request.setAttribute("categoryId", categoryId);
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 15:
                supplierID = request.getParameter("supplierID");
                supplierName = request.getParameter("supplierName");
                String supplierNo = request.getParameter("supplierNo");

                servedPage = "/docs/Adminstration/confirm_delete_supplier.jsp";
                request.setAttribute("supplierID", supplierID);
                request.setAttribute("supplierName", supplierName);
                request.setAttribute("supplierNo", supplierNo);
                request.setAttribute("canDelete", supplierMgr.canDelete(supplierID));
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 16:
                supplierMgr = SupplierMgr.getInstance();
                        String responseString = supplierMgr.getAllSuppNo();
                        if (responseString != null) {
                            response.setContentType("text/xml");
                            response.setHeader("Cache-Control", "no-cache");
                            response.getWriter().write(responseString);
                        } else {
                            // If key comes back as a null, return a question mark.
                            response.setContentType("text/xml");
                            response.setHeader("Cache-Control", "no-cache");
                            response.getWriter().write("?");
                        }
                        break;
                
            case 17:
                WebBusinessObject loggerWbo = new WebBusinessObject();
                fillLoggerWbo(request, loggerWbo);
                if (supplierMgr.deleteOnSingleKey(request.getParameter("supplierId"))) {
                    try {
                        loggerMgr.saveObject(loggerWbo);
                    } catch (SQLException ex) {
                        logger.error(ex.getMessage());
                    }
                }

                this.forward("SupplierServlet?op=ListSuppliers", request, response);
                break;
                
            default:
                System.out.println("No operation was matched");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Equipment Servlet";
    }

    @Override
    protected int getOpCode(String opName) {
        if(opName.indexOf("GetSupplierForm") == 0)
            return 1;
        
        if(opName.indexOf("SaveSupplier") == 0)
            return 2;
        
        if(opName.indexOf("ListSuppliers") == 0)
            return 3;
        
        if(opName.indexOf("ViewSupplier") == 0)
            return 4;
        
        if(opName.indexOf("GetUpdateForm") == 0)
            return 5;
        
        if(opName.equalsIgnoreCase("UpdateSupplier"))
            return 6;
        
        if(opName.equalsIgnoreCase("GetItemSupplierForm"))
            return 7;
        
        if(opName.equalsIgnoreCase("SaveItemSupplier"))
            return 8;
        
        if(opName.equalsIgnoreCase("ListItemSuppliers"))
            return 9;
        
        if(opName.equalsIgnoreCase("ViewItemSupplier"))
            return 10;
        
        if(opName.indexOf("GetUpdateItemSupplierForm") == 0)
            return 11;
        
        if(opName.indexOf("UpdateItemSupplier") == 0)
            return 12;
        
        if(opName.indexOf("ConfirmItemSupplierDelete") == 0)
            return 13;
        
        if(opName.indexOf("DeleteItemSupplier") == 0)
            return 14;
        
        if(opName.indexOf("ConfirmDeleteSupp") == 0)
            return 15;
        
        if(opName.indexOf("SuppNoList") == 0)
            return 16;
        
        if(opName.indexOf("delete") == 0)
            return 17;
        
        return 0;
    }

    private void fillLoggerWbo(HttpServletRequest request, WebBusinessObject loggerWbo) {
        WebBusinessObject objectXml = supplierMgr.getOnSingleKey(request.getParameter("supplierId"));
        loggerWbo.setAttribute("objectXml", objectXml.getObjectAsXML());
        loggerWbo.setAttribute("realObjectId", request.getParameter("supplierId"));
        loggerWbo.setAttribute("userId", securityUser.getUserId());
        loggerWbo.setAttribute("objectName", "Supplier");
        loggerWbo.setAttribute("loggerMessage", "Supplier Deleted");
        loggerWbo.setAttribute("eventName", "Delete");
        loggerWbo.setAttribute("objectTypeId", "7");
        loggerWbo.setAttribute("eventTypeId", "2");
    }
}
