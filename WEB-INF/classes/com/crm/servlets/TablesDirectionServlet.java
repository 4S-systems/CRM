package com.crm.servlets;

import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.common.EmpRelationMgr;
import com.silkworm.common.MetaDataMgr;
import com.silkworm.common.UserMgr;
import com.tracker.db_access.ProjectMgr;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.tracker.servlets.TrackerBaseServlet;
import java.util.AbstractMap;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;

public class TablesDirectionServlet extends TrackerBaseServlet {

    private ProjectMgr projectMgr;
    private UserMgr userMgr;
    private EmpRelationMgr empRelationMgr;

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

        projectMgr = ProjectMgr.getInstance();
        userMgr = UserMgr.getInstance();
        empRelationMgr = EmpRelationMgr.getInstance();

        switch (operation) {

            case 1:
                servedPage = "/docs/reports/view_employees_managers.jsp";
                List<Map.Entry<String, List<String>>> data = new ArrayList<Map.Entry<String, List<String>>>();
                Map.Entry<String, List<String>> entry;
                List<String> employees;
                String department;
                String managerId;
                String employeeName;
                Vector<WebBusinessObject> manages = projectMgr.getRealProject();
                Vector<WebBusinessObject> employeeManagers;
                for (WebBusinessObject wbo : manages) {
                    employees = new ArrayList<String>();
                    managerId = (String) wbo.getAttribute("optionOne");
                    WebBusinessObject managerWbo = userMgr.getOnSingleKey(managerId);
                    department = (String) wbo.getAttribute("projectName") + " (" + (managerWbo != null && managerWbo.getAttribute("fullName") != null ? (String) managerWbo.getAttribute("fullName") : "لا يوجد مدير") + ")";
                    try {
                        employeeManagers = empRelationMgr.getOnArbitraryKey(managerId, "key1");
                        for (WebBusinessObject employeeManager : employeeManagers) {
                            employeeName = userMgr.getByKeyColumnValue("key", (String) employeeManager.getAttribute("empId"), "key3");
                            if (employeeName != null) {
                                employees.add(employeeName);
                            }
                        }

                        entry = new AbstractMap.SimpleEntry<String, List<String>>(department, employees);
                        data.add(entry);
                    } catch (Exception ex) {
                        logger.error(ex);
                    }
                }
                request.setAttribute("data", data);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 2:
                servedPage = "/docs/reports/view_main_dep_employees.jsp";
                data = new ArrayList<Map.Entry<String, List<String>>>();
                try {
                    ArrayList<WebBusinessObject> mainDepartments = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKeyOracle(MetaDataMgr.getInstance().getDepartmentRootID(), "key2"));
                    ArrayList<WebBusinessObject> departmentEmployees;
                    for (WebBusinessObject departmentWbo : mainDepartments) {
                        employees = new ArrayList<String>();
                        managerId = (String) departmentWbo.getAttribute("optionOne");
                        WebBusinessObject managerWbo = userMgr.getOnSingleKey(managerId);
                        department = (String) departmentWbo.getAttribute("projectName") + " (" + (managerWbo != null && managerWbo.getAttribute("fullName") != null ? (String) managerWbo.getAttribute("fullName") : "لا يوجد مدير") + ")";
                        try {
                            departmentEmployees = userMgr.getEmployeesByDepartmentCode((String) departmentWbo.getAttribute("eqNO"));
                            for (WebBusinessObject employeeWbo : departmentEmployees) {
                                employeeName = (String) employeeWbo.getAttribute("fullName");
                                if (employeeName != null) {
                                    employees.add(employeeName);
                                }
                            }

                            entry = new AbstractMap.SimpleEntry<String, List<String>>(department, employees);
                            data.add(entry);
                        } catch (Exception ex) {
                            logger.error(ex);
                        }
                    }
                    request.setAttribute("data", data);
                } catch (Exception ex) {
                    Logger.getLogger(TablesDirectionServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
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
        return "Tables Direction Servlet";
    }

    @Override
    protected int getOpCode(String opName) {
        if (opName.equals("viewEmployeesManagers")) {
            return 1;
        }
        if (opName.equals("viewMainDepartmentEmployees")) {
            return 2;
        }
        return 0;
    }
}
