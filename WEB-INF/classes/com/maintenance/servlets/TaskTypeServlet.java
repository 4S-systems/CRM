/*
 * TechServlet.java
 *
 * Created on February 6, 2007, 1:54 PM
 */

package com.maintenance.servlets;

import com.maintenance.db_access.TaskTypeMgr;
import com.maintenance.db_access.TechMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.tracker.servlets.TrackerBaseServlet;
import java.io.*;

import java.util.Vector;
import javax.servlet.*;
import javax.servlet.http.*;

/**
 *
 * @author image
 * @version
 */
public class TaskTypeServlet extends TrackerBaseServlet {

    TaskTypeMgr taskTypeMgr = TaskTypeMgr.getInstance();
    WebBusinessObject taskType;

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
                    servedPage = "/docs/TaskType/new_task_type.jsp";
                    request.setAttribute("page",servedPage);
                    this.forwardToServedPage(request, response);
                break;

            case 2:
                String name = request.getParameter("name");
                String desc = request.getParameter("desc");
                servedPage = "TaskTypeServlet?op=getTaskTypeForm";
                if(!taskTypeMgr.nameExsit(name)){
                    taskType = new WebBusinessObject();
                    taskType.setAttribute("name", name);
                    taskType.setAttribute("desc", desc);

                    if(taskTypeMgr.saveObject(taskType)){
                        shipBack(request, response, "ok");
                    }else{
                        shipBack(request, response, "error");
                    }
                }else{
                    shipBack(request, response, "errorName");
                }
                break;
            case 3:
                servedPage = "/docs/TaskType/list_task_type.jsp";
                Vector allTaskType = taskTypeMgr.getAllTaskType();
                Vector sub = new Vector();

                int start=0,end=0,pageNo;
                int total = allTaskType.size();
                int pageTotal = total/20;
                int reminder = total%20;
                if(reminder != 0) pageTotal++;
                String page =(String) request.getParameter("pageNo");
                if(page != null){
                    pageNo = Integer.valueOf(page).intValue();
                }else{
                    pageNo = 1;
                }
                if(total > 20){
                        end = pageNo*20;
                        start = end - 20;
                     if(end>total){
                         end = total;
                         start = total - reminder;
                     }
                        for (int i = start; i < end; i++) {
                            sub.addElement(allTaskType.get(i));
                        }
                }else{
                    sub = allTaskType;
                }

                request.setAttribute("pageTotal", pageTotal);
                request.setAttribute("pageNo", pageNo);
                request.setAttribute("total", total);
                request.setAttribute("allTaskType", sub);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;

            case 4:
                servedPage = "docs/TaskType/view_task_type.jsp";
                setRequestInfo(request);
                this.forwardToServedPage(request, response);
                break;

            case 5:
                servedPage = "docs/TaskType/update_task_type.jsp";
                setRequestInfo(request);
                this.forwardToServedPage(request, response);
                break;
            case 6:
                String taskTypeId = request.getParameter("id");
                String oldName = request.getParameter("oldName");
                String newName = request.getParameter("name");
                desc = request.getParameter("desc");
                if((newName.equals(oldName)) || !taskTypeMgr.nameExsit(newName)){
                    WebBusinessObject wboTaskType = new WebBusinessObject();
                    wboTaskType.setAttribute("id", taskTypeId);
                    wboTaskType.setAttribute("name", newName);
                    wboTaskType.setAttribute("desc", desc);
                    if(taskTypeMgr.updateTaskType(wboTaskType)){
                        servedPage = "TaskTypeServlet?op=listTaskType";
                        shipBack(request, response, "ok");
                    }else{
                        servedPage = "TaskTypeServlet?op=updateFormTaskType";
                        shipBack(request, response, "error");
                    }
                }else{
                  servedPage = "TaskTypeServlet?op=updateFormTaskType";
                  shipBack(request, response, "errorName");
                }
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
        return "Search Servlet";
    }

    protected int getOpCode(String opName) {
        if(opName.equalsIgnoreCase("getTaskTypeForm"))
            return 1;
        else if(opName.equalsIgnoreCase("saveTaskType"))
            return 2;
        else if(opName.equalsIgnoreCase("listTaskType"))
            return 3;
        else if(opName.equalsIgnoreCase("viewTaskType"))
            return 4;
        else if(opName.equalsIgnoreCase("updateFormTaskType"))
            return 5;
        else if(opName.equalsIgnoreCase("updateTaskType"))
            return 6;

        return 0;
    }

    private void shipBack(HttpServletRequest request, HttpServletResponse response, String message){
        request.setAttribute("name", request.getParameter("name"));
        request.setAttribute("desc", request.getParameter("desc"));
        request.setAttribute("message", message);
        this.forward(servedPage, request, response);
    }

    private void setRequestInfo(HttpServletRequest request){
        String taskTypeId = request.getParameter("id");

        taskTypeMgr = TaskTypeMgr.getInstance();

        WebBusinessObject wbo = taskTypeMgr.getOnSingleKey(taskTypeId);
        request.setAttribute("page", servedPage);
        request.setAttribute("id", (String) wbo.getAttribute("id"));
        request.setAttribute("name", (String) wbo.getAttribute("name"));
        request.setAttribute("desc", (String) wbo.getAttribute("note"));
    }
}
