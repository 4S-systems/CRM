/*
 * ListerServlet.java
 *
 * Created on March 31, 2004, 2:21 PM
 */
package com.silkworm.servlets;

import com.maintenance.common.Tools;
import com.maintenance.db_access.TradeMgr;
import com.silkworm.business_objects.WebBusinessObject;
import java.io.*;
import java.util.*;

import javax.servlet.*;
import javax.servlet.http.*;

import com.silkworm.common.*;
import com.silkworm.db_access.PersistentSessionMgr;
import java.text.SimpleDateFormat;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;

public class ListerServlet extends swBaseServlet {

    UserMgr userMgr = UserMgr.getInstance();
    GroupMgr groupMgr = GroupMgr.getInstance();
    ApplicationSessionRegistery appRegistry = ApplicationSessionRegistery.getInstance();

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }

    @Override
    public void destroy() {
    }

    @Override
    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        super.processRequest(request, response);

        operation = getOpCode(request.getParameter("op"));
        SecurityUser securityUser = (SecurityUser) request.getSession().getAttribute("securityUser");
        String remoteAccess = request.getSession().getId();
        WebBusinessObject persistentUser = (WebBusinessObject) PersistentSessionMgr.getInstance().getOnSingleKey(remoteAccess);
        switch (operation) {
            case 1:
                String userStatus = request.getParameter("userStatus") != null ? request.getParameter("userStatus") : "active";
                Vector userList = userMgr.getUserWithStatus(userStatus);
                long numberOfUsers = userList.size();//userMgr.countAll();
                servedPage = "/docs/Adminstration/user_list.jsp";
                groupMgr = GroupMgr.getInstance();
                groupMgr.cashData();
                TradeMgr tradeMgr = TradeMgr.getInstance();
                try {
                    request.setAttribute("trades", new ArrayList(tradeMgr.getOnArbitraryKeyOracle("0", "key4")));
                } catch (Exception ex) {
                    Logger.getLogger(ListerServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                ArrayList<WebBusinessObject> rolesList = new ArrayList<WebBusinessObject>(groupMgr.getCashedTable());
                request.setAttribute("data", userList);
                request.setAttribute("numberOfUsers", numberOfUsers);
                request.setAttribute("rolesList", rolesList);
                request.setAttribute("userStatus", userStatus);
		
		request.setAttribute("updtMgr", request.getParameter("updtMgr"));
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 2:
                servedPage = "/docs/Adminstration/current_users.jsp";

                request.setAttribute("data", new Vector());
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 3 :
                  userList = userMgr.getAllRowByIndex();
                  ArrayList<WebBusinessObject> users = new ArrayList<WebBusinessObject>();
                  for (int i = 0; i < userList.size(); i++) {
                    users.add((WebBusinessObject) userList.get(i));
                }
//                groupMgr = GroupMgr.getInstance();
//                groupMgr.cashData();
//                rolesList = new ArrayList<WebBusinessObject>(groupMgr.getCashedTable());
                            
                String attributes[] = {"#", "userId","userName","fullName","password","email","canSendEmail","isSuperUser","CREATION_TIME"};
                String headers[] = {"Number","User ID","User Name","Full Name","Password","E-mail","User Can Send Email ?","Super User ?","Creating Time"};
                String dataTypes[] = {"","String","String","String","String","String","String","String","String"};

                String[] headerStr = new String[1];
                headerStr[0] = "Users_Data";
                    
                HSSFWorkbook workBook = Tools.createExcelReport("users", headerStr, null, headers, attributes, dataTypes, users);
               
                Calendar c = Calendar.getInstance();
                Date fileDate = c.getTime();
                SimpleDateFormat df = new SimpleDateFormat("dd-MM-yyyy");
                String reportDate = df.format(fileDate);
                String filename = "Users" + reportDate;
                
                ServletOutputStream servletOutputStream = response.getOutputStream();    
                ByteArrayOutputStream bos = new ByteArrayOutputStream();
                try {
                    workBook.write(bos);
                } finally {
                    bos.close();
                }
                byte[] bytes = bos.toByteArray();
                System.out.println(bytes.length);
//                bytes = bos.toByteArray();

                response.setContentType("application/vnd.ms-excel");
                response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + ".xls\"");
                response.setContentLength(bytes.length);
                servletOutputStream.write(bytes, 0, bytes.length);
                servletOutputStream.flush();
                servletOutputStream.close();

                break ;
            default:
                break;
        }
    }

    @Override protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override public String getServletInfo() {
        return "Silkworm Lister Sevlet";
    }

    @Override public int getOpCode(String opName) {
        if (opName.equalsIgnoreCase("ListUsers")) {
            return 1;
        }
        if (opName.equalsIgnoreCase("ListAllUsers")) {
            return 2;
        }
        if(opName.equalsIgnoreCase("exportUsersToExcel")){
            return 3 ;
        }
        
        return 0;
    }
}
