package com.tracker.servlets;

import com.contractor.db_access.MaintainableMgr;
import com.contractor.db_access.PeriodicMgr;
import com.silkworm.business_objects.MaintainableUnit;
import com.silkworm.business_objects.WebBusinessObject;
import com.tracker.db_access.IssueMgr;
import com.tracker.db_access.ProjectMgr;
import java.io.*;
import java.net.*;
import java.sql.Date;
import java.util.Calendar;
import java.util.Hashtable;
import java.util.Vector;

import javax.servlet.*;
import javax.servlet.http.*;

public class AppletServlet extends HttpServlet {
    
    private int operation;
    
    private String servedPage;
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
//        PrintWriter out = response.getWriter();
        try {
            operation = getOpCode((String) request.getParameter("op"));
            
            switch (operation) {
                case 1:
                    response.setContentType("text/html");
                    servedPage = "/docs/Adminstration/maintenance_tree.jsp";
                    
                    request.setAttribute("page",servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                    
                case 2:
                    MaintainableMgr maintainableMgr = MaintainableMgr.getInstance();
                    Vector allRoots = maintainableMgr.getRootNodes();
                    Vector roots = new Vector();
                    for(int i = 0; i < allRoots.size(); i++){
                        Hashtable hash = new Hashtable();
                        MaintainableUnit units = (MaintainableUnit) allRoots.get(i);
                        hash = units.getAttributes();
                        roots.add(hash);
                    }
                    ObjectOutputStream outStream = new ObjectOutputStream(response.getOutputStream());
                    outStream.writeObject(roots);
                    outStream.close();
                    break;
                    
                case 3:
                    maintainableMgr = MaintainableMgr.getInstance();
                    Vector allChildrens = maintainableMgr.getChildren(request.getParameter("parentID"));
                    Vector childrens = new Vector();
                    for(int i = 0; i < allChildrens.size(); i++){
                        Hashtable hash = new Hashtable();
                        MaintainableUnit units = (MaintainableUnit) allChildrens.get(i);
                        hash = units.getAttributes();
                        childrens.add(hash);
                    }
                    outStream = new ObjectOutputStream(response.getOutputStream());
                    outStream.writeObject(childrens);
                    outStream.close();
                    break;
                    
                    
                case 4:
                    maintainableMgr = MaintainableMgr.getInstance();
                    ObjectInputStream objin = new ObjectInputStream(request.getInputStream());
                    Hashtable hash = (Hashtable) objin.readObject();
                    response.setContentType("text/html");
                    PrintWriter out = response.getWriter();
                    if(hash != null){
                        if(maintainableMgr.saveNewObject(new WebBusinessObject(hash))){
                            out.println("true");
                        } else {
                            out.println("false");
                        }
                    } else {
                        out.println("false");
                    }
                    out.close();
                    break;
                    
                case 5:
                    maintainableMgr = MaintainableMgr.getInstance();
                    objin = new ObjectInputStream(request.getInputStream());
                    hash = (Hashtable) objin.readObject();
                    response.setContentType("text/html");
                    out = response.getWriter();
                    if(hash != null){
                        if(maintainableMgr.deletObject(new WebBusinessObject(hash))){
                            out.println("true");
                        } else {
                            out.println("false");
                        }
                    } else {
                        out.println("false");
                    }
                    out.close();
                    break;
                    
                case 6:
                    maintainableMgr = MaintainableMgr.getInstance();
                    objin = new ObjectInputStream(request.getInputStream());
                    hash = (Hashtable) objin.readObject();
                    response.setContentType("text/html");
                    out = response.getWriter();
                    if(hash != null){
                        if(maintainableMgr.updateObject(new WebBusinessObject(hash))){
                            out.println("true");
                        } else {
                            out.println("false");
                        }
                    } else {
                        out.println("false");
                    }
                    out.close();
                    break;
                case 7:
                    IssueMgr issueMgr = IssueMgr.getInstance();
                    maintainableMgr = MaintainableMgr.getInstance();
                    
                    objin = new ObjectInputStream(request.getInputStream());
                    hash = (Hashtable) objin.readObject();
                    out = response.getWriter();
                    if(hash != null){
                        WebBusinessObject wbo = new WebBusinessObject(hash);
                        WebBusinessObject wbObject = maintainableMgr.getOnSingleKey((String) wbo.getAttribute("unitID"));
                        int iFrequency = ((Integer) wbo.getAttribute("frequency")).intValue();
                        long interval = 0;
                        if(wbo.getAttribute("frequencyType").toString().equalsIgnoreCase("1")){
                            interval = 7;
                        } else {
                            interval = 30;
                        }
                        Date beginDate = (Date) wbo.getAttribute("beginDate");
                        Calendar c = Calendar.getInstance();
                        c.setTimeInMillis(beginDate.getTime());
                        WebBusinessObject wboIssue = new WebBusinessObject();
                        wboIssue.setAttribute("site", wbObject.getAttribute("site").toString());
                        wboIssue.setAttribute("machine", wbObject.getAttribute("unitName").toString());
                        wboIssue.setAttribute("desc", wbo.getAttribute("desc"));
                        String title = (String) wbo.getAttribute("maintenanceTitle");
                        for(int i = 0; i < iFrequency; i++){
                            wboIssue.setAttribute("maintenanceTitle", title + (i + 1));
                                                       wboIssue.setAttribute("beginDate", new java.sql.Date(c.getTimeInMillis()));
                            c.setTimeInMillis(c.getTimeInMillis() + (interval * 24 * 60 * 60 * 1000));
                                                        wboIssue.setAttribute("endDate", new java.sql.Date(c.getTimeInMillis()));
                            try {
                                issueMgr.saveSchedule(wboIssue, request.getSession());
                            } catch (Exception ex) {
                                
                            }
                        }
                        PeriodicMgr periodicMgr = PeriodicMgr.getInstance();
                        if(periodicMgr.saveNewObject(wbo)){
                            out.println("true");
                        } else {
                            out.println("false");
                        }
                    } else {
                        out.println("false");
                    }
                    out.close();
                    break;
                    
                case 8:
                    ProjectMgr projectMgr = ProjectMgr.getInstance();
                    outStream = new ObjectOutputStream(response.getOutputStream());
                    outStream.writeObject(projectMgr.getCashedTableAsArrayList().toArray());
                    outStream.close();
                    break;
                    
                default:
                    this.forwardToServedPage(request, response);
            }
        } catch(Exception sqlEx) {
            
        }
//        if("object".equals(request.getParameter("type"))){
//
//        } else {
//            response.setContentType("text/html");
//        }
//        out.close();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }
    
    protected int getOpCode(String opName) {
        
        if(opName.equalsIgnoreCase("ViewTree"))
            return 1;
        
        if(opName.equalsIgnoreCase("GetRootNodes")) {
            return 2;
        }
        
        if(opName.equalsIgnoreCase("GetChildren")) {
            return 3;
        }
        
        if(opName.equalsIgnoreCase("SaveUnit")) {
            return 4;
        }
        
        if(opName.equalsIgnoreCase("DeleteUnit")) {
            return 5;
        }
        
        if(opName.equalsIgnoreCase("UpdateUnit")) {
            return 6;
        }
        
        if(opName.equalsIgnoreCase("SaveSchedule")) {
            return 7;
        }
        
        if(opName.equalsIgnoreCase("GetSiteList")) {
            return 8;
        }
        
        return 0;
    }
    
    public String getServletInfo() {
        return "Short description";
    }
    
    protected void forwardToServedPage(HttpServletRequest request, HttpServletResponse response){
        forward("/main.jsp",request, response);
    }
    
    protected void forward(String url ,HttpServletRequest request, HttpServletResponse response) {
        
        try {
            RequestDispatcher rd = request.getRequestDispatcher(url);
            
            rd.forward(request,response);
        }
        
        catch(IOException ioex) {
            
        } catch(Exception general) {
            
        }
    }
    
}
