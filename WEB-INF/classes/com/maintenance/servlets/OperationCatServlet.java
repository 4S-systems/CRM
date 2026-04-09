package com.maintenance.servlets;

import com.businessfw.hrs.db_access.EmployeeMgr;
import java.io.*;
import java.net.*;
import java.util.*;

import javax.servlet.*;
import javax.servlet.http.*;

import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.timeutil.*;
import com.silkworm.jsptags.*;
import com.silkworm.Exceptions.*;

import com.tracker.common.*;
import com.tracker.db_access.*;
import com.tracker.servlets.TrackerBaseServlet;

import com.maintenance.db_access.*;
import com.maintenance.common.*;

import com.contractor.db_access.MaintainableMgr;
//import com.maintenance.db_access.ItemMgr;
public class OperationCatServlet extends TrackerBaseServlet {

    MaintainableMgr unit = MaintainableMgr.getInstance();
    ItemCatsMgr itemCatsMgr = ItemCatsMgr.getInstance();
    CategoryMgr categoryMgr = CategoryMgr.getInstance();
    ItemMgr itemMgr = ItemMgr.getInstance();
    EmployeeMgr employeeMgr = EmployeeMgr.getInstance();
    OperationCatMgr operationCatMgr = OperationCatMgr.getInstance();
    String op = null;
    String filterName = null;
    String filterValue = null;
    String categoryId = null;
    Vector unitsList = null;
    ArrayList unitArr;
    ArrayList itemCategory;

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
                servedPage = "/docs/Adminstration/new_Operation_Cat.jsp";

//                unitArr = new ArrayList();
//                itemCategory = new ArrayList();
//                
//                unit.cashData();
//                categoryMgr.cashData();
//                unitArr = unit.getCashedTableAsBusObjects();
//                itemCategory = categoryMgr.getCashedTableAsBusObjects();

//                request.setAttribute("units", unitArr);
//                request.setAttribute("category", itemCategory);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 2:


                servedPage = "/docs/Adminstration/new_Operation_Cat.jsp";
                WebBusinessObject operation = new WebBusinessObject();

                operation.setAttribute("catCode", request.getParameter("catCode").toString());
                operation.setAttribute("catName", request.getParameter("catName").toString());
                operation.setAttribute("relatedTo", request.getParameter("relatedTo").toString());
                operation.setAttribute("Note", request.getParameter("Note").toString());


                try {
                    if (operationCatMgr.saveObject(operation, session)) {
                        request.setAttribute("Status", "Ok");
                    } else {
                        request.setAttribute("Status", "No");
                    }

                } catch (NoUserInSessionException noUser) {
                    logger.error("Place Servlet: save place " + noUser);
                }


                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 3:
//                String CatName = request.getParameter("categoryName");
//                String Description = request.getParameter("catDsc");
//                
//                WebBusinessObject category = new WebBusinessObject();
//                
//                category.setAttribute("CatName",CatName);
//                category.setAttribute("catDesc",Description);
//                
//                servedPage = "/docs/Adminstration/new_Category.jsp";
//                try {
//                    if(categoryMgr.saveObject(category,session))
//                        request.setAttribute("Status" , "Ok");
//                    else
//                        request.setAttribute("Status", "No");
//                    
//                } catch (NoUserInSessionException noUser) {
//                    logger.error("Place Servlet: save place " + noUser);
//                }
//                
//                //request.setAttribute("data", issuesList);
//                //request.setAttribute("status", "Unassigned");
//                request.setAttribute("page",servedPage);
//                this.forwardToServedPage(request, response);
//                break;
//                
            case 4:
                String issueId = request.getParameter(IssueConstants.ISSUEID);
                String issueTitle = request.getParameter(IssueConstants.ISSUETITLE);

                servedPage = "/docs/Adminstration/new_Category.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 5:
                Vector Operations = new Vector();
                operationCatMgr.cashData();
                Operations = operationCatMgr.getAllItems();
                servedPage = "/docs/Adminstration/OperationCat_List.jsp";

                request.setAttribute("data", Operations);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 6:
//                String employeeId=null;
//                servedPage = "/docs/Adminstration/view_Employee.jsp";
//                employeeId = request.getParameter("employeeId");
//                departmentId=request.getParameter("departmentId");
//                employee = employeeMgr.getOnSingleKey(employeeId);
//                
//                request.setAttribute("departmentId",departmentId);
//                request.setAttribute("employee",employee);
//                request.setAttribute("page",servedPage);
//                this.forwardToServedPage(request, response);
//                
//                break;

            case 7:
//                departmentId=request.getParameter("departmentId");
//                employeeId = request.getParameter("employeeId");
//                employee = employeeMgr.getOnSingleKey(employeeId);
//                
//                servedPage = "/docs/Adminstration/update_Employee.jsp";
//                
//                request.setAttribute("employee",employee);
//                request.setAttribute("employeeId",employeeId);
//                request.setAttribute("departmentId",departmentId);
//                request.setAttribute("page",servedPage);
//                this.forwardToServedPage(request, response);
//                break;


            case 8:

                servedPage = "/docs/Adminstration/update_Employee.jsp";



//                employee = new WebBusinessObject();
//                
//                departmentId=employeeMgr.getDepartmentId(request.getParameter("departmentName").toString());
//                employee.setAttribute("empNO",request.getParameter("empNO").toString());
//                employee.setAttribute("empName",request.getParameter("empName").toString());
//                employee.setAttribute("Address",request.getParameter("Address").toString());
//                employee.setAttribute("Designation",request.getParameter("Designation").toString());
//                employee.setAttribute("workPhone",request.getParameter("workPhone").toString());
//                employee.setAttribute("Extension",request.getParameter("Extension").toString());
//                employee.setAttribute("homePhone",request.getParameter("homePhone").toString());
//                employee.setAttribute("fax",request.getParameter("fax").toString());
//                employee.setAttribute("Email",request.getParameter("Email").toString());
//                employee.setAttribute("departmentName",departmentId);
//                employee.setAttribute("houreSalary",request.getParameter("houreSalary").toString());
//                employee.setAttribute("overTime1",request.getParameter("overTime1").toString());
//                employee.setAttribute("overTime2",overtime2);
//                employee.setAttribute("overTime3",overtime3);
//                employee.setAttribute("Note",request.getParameter("Note").toString());
//                employee.setAttribute("isActive",active);
//                employee.setAttribute("employeeId",request.getParameter("employeeId").toString());
//                
//               
//                    if(employeeMgr.updateEmployee(employee)){
//                        request.setAttribute("Status" , "Ok");
//                    } else  {
//                        request.setAttribute("Status", "No");
//                    
//                } 
//               
//                
//                
//                employee = employeeMgr.getOnSingleKey(request.getParameter("employeeId"));
//                request.setAttribute("employee", employee);
//                request.setAttribute("departmentId", departmentId);


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
//                categoryName = request.getParameter("categoryName");
//                String getCategoryId =categoryMgr.getCategoryId(categoryName);
//                
//                String itemCode = request.getParameter("itemCode");
//                String itemUnit = request.getParameter("itemUnit");
//                String itemUnitPrice = request.getParameter("itemUnitPrice");
//                String itemDscrptn = request.getParameter("itemDscrptn");
//                
//                WebBusinessObject item = new WebBusinessObject();
//                
//                item.setAttribute("categoryName",categoryName);
//                item.setAttribute("getCategoryId",getCategoryId);
//                item.setAttribute("itemCode",itemCode);
//                item.setAttribute("itemUnit",itemUnit);
//                item.setAttribute("itemUnitPrice",itemUnitPrice);
//                item.setAttribute("itemDscrptn",itemDscrptn);
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
//                    logger.error("Place Servlet: save place " + noUser);
//                }
//                
//                //request.setAttribute("data", issuesList);
//                //request.setAttribute("status", "Unassigned");
//                request.setAttribute("page",servedPage);
//                this.forwardToServedPage(request, response);
//                break;

            case 13:
//                Vector categories=new Vector();
//                categoryMgr.cashData();
//                categories = categoryMgr.getAllCategory();
//                servedPage = "/docs/Adminstration/Item_By_Category_List.jsp";
//                
//                request.setAttribute("data", categories);
//                request.setAttribute("page",servedPage);
//                this.forwardToServedPage(request, response);
//                break;

            case 14:

                Vector Totalitems = new Vector();
                categoryId = request.getParameter("categoryId");
                itemMgr.cashData();

                Totalitems = itemMgr.getAllItems(categoryId);
                servedPage = "/docs/Adminstration/Items_List.jsp";

                request.setAttribute("data", Totalitems);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 15:

//                String itemID =null;
//                categoryId=request.getParameter("categoryId");
//                servedPage = "/docs/Adminstration/view_Item.jsp";
//                itemID = request.getParameter("itemID");
//                
//                item = itemMgr.getOnSingleKey(itemID);
//                request.setAttribute("categoryId",categoryId);
//                request.setAttribute("item",item);
//                request.setAttribute("page",servedPage);
//                this.forwardToServedPage(request, response);
//                
                break;

//            case 16:
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
//                break;
//                
//            case 17:
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
//                
//                if(itemMgr.updateItem(item)){
//                    
//                    request.setAttribute("status", "Ok");
//                }
//                item = itemMgr.getOnSingleKey(request.getParameter("itemID"));
//                request.setAttribute("item", item);
//                request.setAttribute("categoryId",getCategoryId);
//                request.setAttribute("itemID",itemID);
//                request.setAttribute("page",servedPage);
//                this.forwardToServedPage(request, response);
//                break;
//                
//            case 18:
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
//                break;
//                
//            case 19:
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
//                
//                break;

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
        if (opName.indexOf("NewOperationCat") == 0) {
            return 1;
        }

        if (opName.indexOf("SaveOperation") == 0) {
            return 2;
        }
        if (opName.equals("SaveCategory")) {
            return 3;
        }
        if (opName.equals("ViewCategoryForm")) {
            return 4;
        }
        if (opName.equals("ListOperationCat")) {
            return 5;
        }

        if (opName.equals("ViewEmployee")) {
            return 6;
        }

        if (opName.equals("GetUpdateEmployee")) {
            return 7;
        }
        if (opName.equals("UpdateEmployee")) {
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

        return 0;
    }
}

