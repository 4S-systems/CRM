package com.tracker.servlets;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.silkworm.business_objects.*;
import java.util.*;
import java.sql.*;
import com.silkworm.util.*;

import com.tracker.db_access.*;
import com.tracker.business_objects.*;
import com.silkworm.Exceptions.*;

import com.silkworm.servlets.*;
import org.apache.log4j.Logger;

public class IssueTypeServlet extends swBaseServlet {
    IssueTypeMgr issueTypeMgr = IssueTypeMgr.getInstance();
    WebIssueType wIssueType = new WebIssueType();
    WebBusinessObject issue = null;
    
    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        servedPage = "/docs/Adminstration/new_issueType.jsp";
        logger = Logger.getLogger(IssueServlet.class);
    }
    
    /** Destroys the servlet.
     */
    @Override
    public void destroy() {
        
    }
    
    /** Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        super.processRequest(request, response);
        HttpSession s = request.getSession();
        String page =null;
        
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            if(this.requestHasNoParams(request)) {
                servedPage = "/docs/Adminstration/new_issueType.jsp";
                request.setAttribute("page",servedPage);
                this.forwardToServedPage(request, response);
            } else {
                operation = getOpCode((String) request.getParameter("op"));
                switch (operation) {
                    case 1:
                        ArrayList requestAsArray = ServletUtils.getRequestParams(request);
                        ServletUtils.printRequest(requestAsArray);
                        servedPage = "/docs/Adminstration/new_issueType.jsp";
                        
                        refineForm(request);
                        if(issueTypeMgr.saveObject(wIssueType, s))
                            request.setAttribute("Status" , "Ok");
                        else
                            request.setAttribute("Status", "No");
                        
                        request.setAttribute("page",servedPage);
                        this.forwardToServedPage(request, response);
                        break;
                        
                    case 2:
                        Vector issueType = issueTypeMgr.getCashedTable();
                        servedPage = "/docs/Adminstration/issue_type_list.jsp";
                        
                        request.setAttribute("data", issueType);
                        request.setAttribute("page",servedPage);
                        this.forwardToServedPage(request, response);
                        break;
                        
                    case 3:
                        String issueName = request.getParameter("issueName");
                        
                        servedPage = "/docs/Adminstration/confirm_del_issuetype.jsp";
                        
                        request.setAttribute("issueName",issueName);
                        request.setAttribute("page",servedPage);
                        this.forwardToServedPage(request, response);
                        break;
                        
                        
                    case 4:
                        WebBusinessObject issue = new WebBusinessObject();
                        servedPage = "/docs/Adminstration/view_issue_type.jsp";
                        issueName = request.getParameter("issueName");
                        
                        issue = issueTypeMgr.getOnSingleKey(issueName);
                        request.setAttribute("issue",issue);
                        request.setAttribute("page",servedPage);
                        this.forwardToServedPage(request, response);
                        
                        break;
                        
                    case 5:
                        issueName = request.getParameter("issueName");
                        issue = issueTypeMgr.getOnSingleKey(issueName);
                        
                        servedPage = "/docs/Adminstration/update_issue_type.jsp";
                        
                        request.setAttribute("issue", issue);
                        
                        request.setAttribute("page",servedPage);
                        this.forwardToServedPage(request, response);
                        break;
                        
                    case 6:
                        servedPage="/docs/Adminstration/update_issue_type.jsp";
                        
                        try {
                            
                            scrapeForm(request,"update");
                            
                            issue = new WebBusinessObject();
                            issue.setAttribute("issueDesc",request.getParameter("issueDesc"));
                            issue.setAttribute("issueName",request.getParameter("issueName"));
                            
                            // do update
                            issueTypeMgr.updateIssueType(issue );
                            
                            // fetch the group again
                            shipBack("ok",request,response);
                            break;
                        }
                        
                        catch(EmptyRequestException ere) {
                            shipBack(ere.getMessage(),request,response);
                            break;
                        }
                        
                        
                        catch(SQLException sqlEx) {
                            shipBack(sqlEx.getMessage(),request,response);
                            break;
                        } catch(NoUserInSessionException nouser) {
                            shipBack(nouser.getMessage(),request,response);
                            break;
                        }
                        
                        catch(Exception Ex) {
                            shipBack(Ex.getMessage(),request,response);
                            break;
                        }
                        
                    case 7:
                        try{
                            IssueMgr issueMgr = IssueMgr.getInstance();
                            Integer iTemp = new Integer(issueMgr.hasData("ISSUE_TYPE", request.getParameter("issueName")));
                            if(iTemp.intValue() > 0) {
                                servedPage="/docs/Adminstration/cant_delete.jsp";
                                request.setAttribute("servlet", "IssueTypeServlet");
                                request.setAttribute("list", "ListIssueTypes");
                                request.setAttribute("type", "Task Type");
                                request.setAttribute("name", request.getParameter("issueName"));
                                request.setAttribute("no", iTemp.toString());
                                request.setAttribute("page",servedPage);
                            } else {
                                issueTypeMgr.deleteOnSingleKey(request.getParameter("issueName"));
                                issueTypeMgr.cashData();
                                issueType = issueTypeMgr.getCashedTable();
                                servedPage = "/docs/Adminstration/issue_type_list.jsp";
                                
                                request.setAttribute("data", issueType);
                                request.setAttribute("page",servedPage);
                            }
                            this.forwardToServedPage(request, response);
                        } catch(NoUserInSessionException ne) {
                        }
                        
                        break;
                        
                    default:
                        this.forwardToServedPage(request, response);
                }
            }
        }
//        catch(SQLException sqlEx)
//        {
//            // forward to errot page
//        }
        catch(Exception sqlEx) {
            // forward to error page
            logger.error( sqlEx.getMessage());
        }
    }
    
    /** Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }
    
    /** Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }
    
    /** Returns a short description of the servlet.
     */
    public String getServletInfo() {
        return "Short description";
    }
    
    private void refineForm(HttpServletRequest request) {
        wIssueType.setIssueName((String)request.getParameter("issueName"));
        wIssueType.setIssueDesc((String)request.getParameter("issueDesc"));
    }
    
    protected int getOpCode(String opName) {
        
        if(opName.equalsIgnoreCase("SaveIssueType"))
            return 1;
        
        if(opName.equalsIgnoreCase("ListIssueTypes")) {
            return 2;
        }
        
        if(opName.equalsIgnoreCase("ConfirmDelete")) {
            return 3;
        }
        
        if(opName.equalsIgnoreCase("ViewIssueType")) {
            return 4;
        }
        
        if(opName.equalsIgnoreCase("GetUpdateForm")) {
            return 5;
        }
        
        if(opName.equalsIgnoreCase("UpdateIssueType")) {
            return 6;
        }
        
        if(opName.equalsIgnoreCase("Delete")) {
            return 7;
        }
        
        return 0;
    }
    
    private void scrapeForm(HttpServletRequest request,String mode) throws EmptyRequestException,EntryExistsException,SQLException,Exception {
        
        String issueName = request.getParameter("issueName");
        String issueDesc = request.getParameter("issueDesc");
        
        if(issueName==null || issueDesc.equals("")) {
            throw new EmptyRequestException(tGuide.getMessage("incompleteinput"));
        }
        
        if( issueName.equals("") || issueDesc.equals(""))
            throw new EmptyRequestException(tGuide.getMessage("incompleteinput"));
        
        if(mode.equalsIgnoreCase("insert")) {
            WebBusinessObject existingIssueType =issueTypeMgr.getOnSingleKey(issueName);
            
            if(existingIssueType!=null)
                throw new EntryExistsException();
            
        }
    }
    
    private void shipBack(String message,HttpServletRequest request,HttpServletResponse response) {
        issue = issueTypeMgr.getOnSingleKey(request.getParameter("issueName"));
        request.setAttribute("issue", issue);
        request.setAttribute("status",message);
        request.setAttribute("page",servedPage);
        this.forwardToServedPage(request, response);
        
    }
}
