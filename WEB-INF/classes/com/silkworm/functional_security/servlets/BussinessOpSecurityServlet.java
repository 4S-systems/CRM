/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.silkworm.functional_security.servlets;

import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.common.UserMgr;
import com.silkworm.functional_security.db_access.BusinessOpSecurityMgr;
import com.silkworm.functional_security.db_access.UserBussinessOpMgr;
import com.silkworm.servlets.UsersServlet;
import com.silkworm.servlets.swBaseServlet;
import java.util.logging.Logger;
import javax.servlet.*;
import javax.servlet.http.*;

import java.util.*;
import java.io.*;
import java.util.logging.Level;
/**
 *
 * @author wesam
 */
public class BussinessOpSecurityServlet extends swBaseServlet{

    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            super.processRequest(request, response);
            operation = getOpCode((String) request.getParameter("op"));
         switch (operation) {
            case 1:
                servedPage = "/docs/user_security/assign_user_bus_priv.jsp";
                BusinessOpSecurityMgr businessOpSecurityMgr= BusinessOpSecurityMgr.getInstance();
                UserMgr userMgr= UserMgr.getInstance();
                Vector opSecList=businessOpSecurityMgr.getOpSecurityList();
                String userId = request.getParameter("userId");
                WebBusinessObject userWbo = userMgr.getOnSingleKey(userId);
                String userName = "";
                if (userWbo != null) {
                    userName = (String) userWbo.getAttribute("userName");
                }
                request.setAttribute("userId", userId);
                request.setAttribute("userName", userName);
                request.setAttribute("busPrevliges", opSecList);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
      
            case 2:
                servedPage = "/docs/user_security/assign_user_bus_priv.jsp";
                UserBussinessOpMgr bussinessOpMgr = UserBussinessOpMgr.getInstance();
                userId = request.getParameter("userId");
                 String[] checks = request.getParameterValues("checkPrev");
                 List<String> test = Arrays.asList(checks);
                 for(int i=0 ; i< checks.length ;i++){
                     if(bussinessOpMgr.saveObject(userId, checks[i])){
                        
                          request.setAttribute("status", "ok");
                     }
                     else
                     {
                         request.setAttribute("status", "no");
                     }
                     
                 }
                 businessOpSecurityMgr= BusinessOpSecurityMgr.getInstance();
                 userMgr= UserMgr.getInstance();
                 opSecList=businessOpSecurityMgr.getOpSecurityList();
                 userWbo = userMgr.getOnSingleKey(userId);
                 userName = "";
                if (userWbo != null) {
                    userName = (String) userWbo.getAttribute("userName");
                }
                
                request.setAttribute("userId", userId);
                request.setAttribute("userName", userName);
                request.setAttribute("busPrevliges", opSecList);
                //request.getSession().setAttribute("checks", test);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
          
                case 3:
                servedPage = "/docs/user_security/view_user_bus_priv.jsp";
                userId = request.getParameter("userId");
                businessOpSecurityMgr= BusinessOpSecurityMgr.getInstance();
                opSecList=businessOpSecurityMgr.getOpSecurityList();
                UserBussinessOpMgr userBussinessOpMgr= UserBussinessOpMgr.getInstance() ;
                Vector checked=userBussinessOpMgr.getOpListById(userId); 
                Vector<String> check = new Vector<String>();
                    for (int i = 0; i < checked.size(); i++) {
                        WebBusinessObject wbo = (WebBusinessObject) checked.get(i);
                        check.add(wbo.getAttribute("bussID").toString());
                    }
                request.setAttribute("checks", checked);
                request.setAttribute("checkOps", check);
                request.setAttribute("busPrevliges", opSecList);
                bussinessOpMgr = UserBussinessOpMgr.getInstance();
                 businessOpSecurityMgr= BusinessOpSecurityMgr.getInstance();
                  
                 
                 userMgr= UserMgr.getInstance();
                 WebBusinessObject secWbo = null;
                
                 userWbo = userMgr.getOnSingleKey(userId);
                 userName = "";
                if (userWbo != null) {
                    userName = (String) userWbo.getAttribute("userName");
                }
         //       for(int i=0 ; i<opSecList.size();i++){
//                    secWbo = (WebBusinessObject) opSecList.get(i);
//                   list =businessOpSecurityMgr.getOpSecurityById((String)secWbo.getAttribute("bussID"));
//                    userOpSecList.add(list);
//                }
                request.setAttribute("userId", userId);
                request.setAttribute("userName", userName);
                
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
         
         }
         
    } catch (Exception ex) {
        Logger.getLogger(UsersServlet.class.getName()).log(Level.SEVERE, null, ex);
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
    
    @Override
    protected int getOpCode(String opName) {
        if (opName.equals("assignFuncSecutiry")) {
            return 1;
        }   if (opName.equals("saveUserBussiness")) {
            return 2;
        }
         if (opName.equals("viewFuncSecutiry")) {
            return 3;
         }

        return 0;
    }
}
