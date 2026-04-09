/*
 * GroupServlet.java
 *
 * Created on January 16, 2004, 3:01 AM
 */
package com.crm.servlets;

import com.crm.db_access.EmployeesLoadsMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.common.SecurityUser;
import com.silkworm.persistence.relational.NoSuchColumnException;
import com.silkworm.persistence.relational.UnsupportedConversionException;
import com.tracker.servlets.TrackerBaseServlet;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author walid
 * @version
 */
public class EmployeesLoadsServlet extends TrackerBaseServlet {

    private EmployeesLoadsMgr loadsMgr;
    private List<WebBusinessObject> loads;
    private String groupId;

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
        HttpSession session = request.getSession();
        SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");

        loadsMgr = EmployeesLoadsMgr.getInstance();
        operation = getOpCode((String) request.getParameter("op"));

        switch (operation) {
            case 1:
                servedPage = "/docs/reports/employees_loads.jsp";
                groupId = request.getParameter("groupId");
                if (groupId == null) {
                    groupId = securityUser.getDefaultNewClientDistribution();
                }
                loads = new ArrayList<WebBusinessObject>();
                try {
                    loads = loadsMgr.getEmployeesLoadDynamicReportByGroup(groupId);
                } catch (NoSuchColumnException ex) {
                    logger.error(ex);
                } catch (UnsupportedConversionException ex) {
                    logger.error(ex);
                }
                request.setAttribute("page", servedPage);
                request.setAttribute("loads", loads);
                this.forwardToServedPage(request, response);
                break;

            default:
                break;
        }
    }

    @Override
    public String getServletInfo() {
        return "Group Servlet";
    }

    @Override
    protected int getOpCode(String opName) {
        if (opName.equalsIgnoreCase("employeesLoads")) {
            return 1;
        }

        return 0;
    }
}
