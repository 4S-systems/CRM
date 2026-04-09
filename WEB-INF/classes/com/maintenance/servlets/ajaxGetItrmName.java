/*
 * ajaxGetItrmName.java
 *
 * Created on 27 ?????, 2007, 11:12 ?
 */

package com.maintenance.servlets;

import com.maintenance.common.ConfigFileMgr;
import com.maintenance.db_access.ActiveStoreMgr;
import com.maintenance.db_access.DistributedItemsMgr;
import com.maintenance.db_access.ItemsMgr;
import com.maintenance.db_access.LocalStoresItemsMgr;
import com.maintenance.db_access.MaintenanceItemMgr;
import com.maintenance.db_access.PriceItemByBranchMgr;
import com.silkworm.business_objects.WebBusinessObject;

import java.io.*;
import java.net.*;
import java.util.ArrayList;
import java.util.Vector;

import javax.servlet.*;
import javax.servlet.http.*;
import com.tracker.servlets.TrackerBaseServlet;
import java.util.List;

/**
 *
 * @author silkworm4
 * @version
 */
public class ajaxGetItrmName extends TrackerBaseServlet {
    
    private Vector machineItems;
    
    /** Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        
        
    }
    
    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String name=" ";
        String code=request.getParameter("key").toString();
        String price="0";
        String id=" ";
        String Des=" ";
        String cat=" ";
        String branchCode = "";
        String storeCode ="";
        String saveQuantity=null;
        String itemName=request.getParameter("key").toString();
        String groupType = request.getParameter("group").toString();
        
        HttpSession session = request.getSession();
        
        
        try{
            
            WebBusinessObject userWbo=(WebBusinessObject)session.getAttribute("loggedUser");
            String userType=(String)userWbo.getAttribute("userType");
            String storeId="";
            
//            if(userType.equalsIgnoreCase("multi")){
            
            DistributedItemsMgr distItemsMgr=DistributedItemsMgr.getInstance();
            ItemsMgr itemsMgr = ItemsMgr.getInstance();
            PriceItemByBranchMgr priceItemByBranchMgr = PriceItemByBranchMgr.getInstance();
            Vector itemByPriceVec = new Vector();
            Vector itemByPriceByBranchVec = new Vector();
            WebBusinessObject itemByPriceWbo = new WebBusinessObject();

            ActiveStoreMgr activeStoreMgr = ActiveStoreMgr.getInstance();
            WebBusinessObject activeStoreWbo = new WebBusinessObject();
            Vector activeStoreVec = new Vector();
            activeStoreVec = activeStoreMgr.getActiveStore(session);

//            if (activeStoreVec.size() > 0) {
                activeStoreWbo = (WebBusinessObject) activeStoreVec.get(0);
//                request.getSession().setAttribute("branchCode", activeStoreWbo.getAttribute("branchCode").toString());
//                request.getSession().setAttribute("storeCode", activeStoreWbo.getAttribute("storeCode").toString());
//            }
            storeCode =activeStoreWbo.getAttribute("storeCode").toString();

            storeId=userWbo.getAttribute("storeId").toString();
            Vector arrMachineItems=new Vector();
            
            branchCode = activeStoreWbo.getAttribute("branchCode").toString();
             
            
            if(storeId.equalsIgnoreCase("nostore")){
//                distItemsMgr.cashData();
//                arrMachineItems= distItemsMgr.getCashedTable();
                 arrMachineItems= itemsMgr.getOnArbitraryDoubleKey(groupType+"-"+code,"key",storeCode,"key5");
            }else{
                if(userType.equalsIgnoreCase("multi")){
                    arrMachineItems= distItemsMgr.getStoreParts(storeId);
                }else{
                    arrMachineItems= distItemsMgr.getCashedTable();
                }
            }
            
            for(int i = 0; i < arrMachineItems.size(); i++){
                WebBusinessObject  wbo = (WebBusinessObject)arrMachineItems.get(i);
                String itemCode=wbo.getAttribute("itemCode").toString();
                String itemForm=wbo.getAttribute("itemForm").toString();
//                itemByPriceVec = priceItemByBranchMgr.getOnArbitraryDoubleKey(wbo.getAttribute("itemForm").toString(), "key1", wbo.getAttribute("itemCode").toString(), "key");
//                if(itemByPriceVec.size()>0){
//                for(int x=0;x<itemByPriceVec.size();x++){
//                    itemByPriceWbo= (WebBusinessObject) itemByPriceVec.get(x);
//                    if(itemByPriceWbo.getAttribute("branch") != null && !itemByPriceWbo.getAttribute("branch").equals("") && itemByPriceWbo.getAttribute("branch").equals(branchCode)){
//                        itemByPriceByBranchVec.add(itemByPriceWbo);
//                    }
//                }
//                itemByPriceWbo= (WebBusinessObject) itemByPriceByBranchVec.get(0);
//                }
                if(itemCode.equals(code)){
                    name=wbo.getAttribute("itemDscrptn").toString();
//                    if(itemByPriceVec.size()>0){
//                     if(null != itemByPriceWbo.getAttribute("price")){
//                            price=itemByPriceWbo.getAttribute("price").toString();
//                        }else {
//                        price ="0.0";
//                        }
//                    } else {
//                        price ="0.0";
//                    }
                     if(wbo.getAttribute("itemLastPrice") != null && !wbo.getAttribute("itemLastPrice").equals("")){
                        price = (String) wbo.getAttribute("itemLastPrice");
                        }else {
                        price ="0";
                        }
                    id=wbo.getAttribute("itemForm").toString()+"-"+wbo.getAttribute("itemCode").toString();
                    Des=wbo.getAttribute("itemDscrptn").toString();
                    cat="";
                    break;
                }
                
            }
            
//            }else{
//                MaintenanceItemMgr maintenanceItemMgr = MaintenanceItemMgr.getInstance();
//                maintenanceItemMgr.cashData();
//                machineItems = new Vector();
//                ArrayList arrMachineItems = maintenanceItemMgr.getCashedTableAsBusObjects();
//                for(int i = 0; i < arrMachineItems.size(); i++){
//                    WebBusinessObject  wbo = (WebBusinessObject)arrMachineItems.get(i);
//                    String itemCode=wbo.getAttribute("itemCode").toString();
//                    if(itemCode.equalsIgnoreCase(code)){
//                        name=wbo.getAttribute("itemDscrptn").toString();
//                        price=wbo.getAttribute("itemUnitPrice").toString();
//                        id=wbo.getAttribute("itemID").toString();
//                        Des=wbo.getAttribute("itemDscrptn").toString();
//                        cat=wbo.getAttribute("categoryName").toString();
//                        break;
//                    }
//
//                }
//            }
            
        } catch (Exception ex){
            System.out.println("Get Machine Category Items Exception "+ex.getMessage());
        }
        response.setContentType("text/xml;charset=UTF-8");
        
        response.setHeader("Cache-Control", "no-cache");
        String re=name+"$$"+price+"$$"+id+"$$"+Des+"$$"+cat+"$$"+branchCode+"$$"+storeCode;
        System.err.println(re);
        response.getWriter( ).write(re);
        
    }
    
    /** Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        
        String mode=request.getParameter("key").toString();
        HttpSession session = request.getSession();
//        String groupType = (String)request.getParameter("group");
        String storeCode="";
        ActiveStoreMgr activeStoreMgr = ActiveStoreMgr.getInstance();
        Vector activeStoreVec = new Vector();
        WebBusinessObject activeStoreWbo = new WebBusinessObject();
      /*  activeStoreVec = activeStoreMgr.getActiveStore(session);
        if(activeStoreVec.size()>0) {
            activeStoreWbo = (WebBusinessObject)activeStoreVec.get(0);
            storeCode =activeStoreWbo.getAttribute("storeCode").toString();

           }

        */
        
        if(!mode.equals("aa")){
            if(mode.equals("En")||mode.equals("Ar")){
                
                request.getSession().removeAttribute("currentMode");
                request.getSession().setAttribute("currentMode",mode);

                ///////////////////// set curren Mode in ConfigFileMgr
                ConfigFileMgr.setCurrentlanguage(mode);

               // response.setContentType("text/xml;charset=UTF-8");
              //  response.setHeader("Cache-Control", "no-cache");
              //  response.getWriter().write("good");
            }
            
        } else{
            StringBuffer  returnXML = new StringBuffer();
            StringBuffer  tempNames = new StringBuffer();
            
            try{
                String groupType = (String)request.getParameter("group");
                WebBusinessObject userWbo=(WebBusinessObject)session.getAttribute("loggedUser");
                String userType=(String)userWbo.getAttribute("userType");
                String storeId="";
                
//                if(userType.equalsIgnoreCase("multi")){
                
                DistributedItemsMgr distItemsMgr=DistributedItemsMgr.getInstance();
                ItemsMgr itemsMgr = ItemsMgr.getInstance();
                
                storeId=userWbo.getAttribute("storeId").toString();
//               storeCode = request.getSession().getAttribute("storeCode").toString();
//                    distItemsMgr.cashData();
//                    ArrayList arrMachineItems= distItemsMgr.getCashedTableAsBusObjects();
                Vector arrMachineItems=new Vector();
                
                if(storeId.equalsIgnoreCase("nostore")){
//                    distItemsMgr.cashData();
//                    itemsMgr.cashData();
                    System.out.print("Grouping ........"+groupType);
                    arrMachineItems= itemsMgr.getOnArbitraryDoubleKey(groupType,"key4",storeCode,"key5");
//                    arrMachineItems= itemsMgr.getOnArbitraryKey(groupType,"key4");
//                    arrMachineItems= itemsMgr.getCashedTable();
                }else{
                    if(userType.equalsIgnoreCase("multi")){
                        arrMachineItems= distItemsMgr.getStoreParts(storeId);
                    }else{
                        arrMachineItems= distItemsMgr.getCashedTable();
                    }
                }
                
                int i = 0;
                String name,code;
                for(; i < arrMachineItems.size(); i++){
                    
                    WebBusinessObject  wbo = (WebBusinessObject)arrMachineItems.get(i);
                    if(wbo.getAttribute("itemDscrptn")!=null && wbo.getAttribute("itemCode")!=null) {
                        code=wbo.getAttribute("itemCode").toString()+"!=";
                        name=wbo.getAttribute("itemDscrptn").toString()+"!=";
                        
                        returnXML.append(code);
                        tempNames.append(name);
                    }
                }
                returnXML.deleteCharAt(returnXML.length( ) - 1);
                returnXML.deleteCharAt(returnXML.length( ) - 1);
                returnXML.append("&#");
                
                tempNames.deleteCharAt(tempNames.length( ) - 1);
                tempNames.deleteCharAt(tempNames.length( ) - 1);
                
                returnXML.append(tempNames);
                
//                }else{
//
//                    MaintenanceItemMgr maintenanceItemMgr = MaintenanceItemMgr.getInstance();
//                    maintenanceItemMgr.cashData();
//
//                    ArrayList arrMachineItems = maintenanceItemMgr.getCashedTableAsBusObjects();
//                    int i = 0;
//                    String ttemp;
//                    for(; i < arrMachineItems.size(); i++){
//
//                        WebBusinessObject  wbo = (WebBusinessObject)arrMachineItems.get(i);
//                        if(wbo.getAttribute("itemDscrptn")!=null && wbo.getAttribute("itemCode")!=null) {
//                            ttemp=wbo.getAttribute("itemCode").toString()+"!=";
//                            returnXML.append(ttemp);
//                        }
//                    }
//                    returnXML.deleteCharAt(returnXML.length( ) - 1);
//                    returnXML.deleteCharAt(returnXML.length( ) - 1);
//                    returnXML.append("&#");
//                    for(i=0; i < arrMachineItems.size(); i++){
//
//                        WebBusinessObject  wbo = (WebBusinessObject)arrMachineItems.get(i);
//                        if(wbo.getAttribute("itemDscrptn")!=null && wbo.getAttribute("itemCode")!=null) {
//                            ttemp=wbo.getAttribute("itemDscrptn").toString()+"!=";
//                            returnXML.append(ttemp);
//                        }
//                    }
//                    returnXML.deleteCharAt(returnXML.length( ) - 1);
//                    returnXML.deleteCharAt(returnXML.length( ) - 1);
//                    //if(wbo.getAttribute())
//                }
                
            } catch (Exception ex){
                System.out.println("Get Machine Category Items Exception "+ex.getMessage());
            }
            
            response.setContentType("text/xml;charset=UTF-8");
            System.err.println(returnXML.toString());
            response.setHeader("Cache-Control", "no-cache");
            response.getWriter().write(returnXML.toString( ));
        }
        
    }
    
    /** Returns a short description of the servlet.
     */
    public String getServletInfo() {
        return "Short description";
    }
    // </editor-fold>
}
