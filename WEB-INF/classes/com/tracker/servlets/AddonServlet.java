package com.tracker.servlets;

import com.maintenance.common.Tools;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.silkworm.business_objects.*;
import com.tracker.common.*;
import org.apache.log4j.Logger;
import com.silkworm.db_access.PersistentSessionMgr;
import com.tracker.db_access.UnitAddonDetailsMgr;
import java.sql.SQLException;
import java.util.logging.Level;

public class AddonServlet extends TrackerBaseServlet {

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        logger = Logger.getLogger(AddonServlet.class);
    }

    @Override
    public void destroy() {
    }

    @Override
    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        super.processRequest(request, response);
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession();
        String remoteAccess = session.getId();
        WebBusinessObject persistentUser = (WebBusinessObject) PersistentSessionMgr.getInstance().getOnSingleKey(remoteAccess);
        operation = getOpCode((String) request.getParameter("op"));
        UnitAddonDetailsMgr unitAddonDetailsMgr = UnitAddonDetailsMgr.getInstance();
        switch (operation) {
            case 1:
                out = response.getWriter();
                WebBusinessObject wbo = new WebBusinessObject();
                wbo.setAttribute("unitID", request.getParameter("projectID"));
                wbo.setAttribute("type", request.getParameter("type"));
                wbo.setAttribute("price", request.getParameter("price"));
                wbo.setAttribute("area", request.getParameter("area"));
                wbo.setAttribute("meterPrice", "0");
                wbo.setAttribute("optionOne", "UL");
                wbo.setAttribute("optionTwo", "UL");

                if (request.getParameter("checkUpdate").equals("0")) {   // save a new addon
                    try {
                        wbo.setAttribute("status", unitAddonDetailsMgr.saveObject(wbo) ? "ok" : "fail");
                    } catch (SQLException ex) {
                        wbo.setAttribute("status", "fail");
                    }
                } else if (request.getParameter("checkUpdate").equals("1")) //update existin add 
                {

                    wbo.setAttribute("unitID", request.getParameter("projectID"));
                    wbo.setAttribute("type", request.getParameter("type1"));
                    wbo.setAttribute("price", request.getParameter("price1"));
                    wbo.setAttribute("area", request.getParameter("area1"));
                    wbo.setAttribute("meterPrice", "0");
                    wbo.setAttribute("optionOne", "UL");
                    wbo.setAttribute("optionTwo", "UL");
                    try {
                        unitAddonDetailsMgr.deleteOnArbitraryDoubleKey((String) request.getParameter("type1"), "key3", request.getParameter("projectID"), "key2");
                        wbo.setAttribute("status", unitAddonDetailsMgr.saveObject(wbo) ? "ok" : "fail");
                    } catch (Exception ex) {
                        wbo.setAttribute("status", "fail");
                    }

                }

                out.write(Tools.getJSONObjectAsString(wbo));
                break;
            case 2:
                WebBusinessObject wbo1 = new WebBusinessObject();
                wbo1.setAttribute("unitID", request.getParameter("projectID"));
                wbo1.setAttribute("type", request.getParameter("type1"));
                try {

                       unitAddonDetailsMgr.deleteOnArbitraryDoubleKey((String) request.getParameter("type1"), "key3", request.getParameter("projectID"), "key2");
                       wbo1.setAttribute("status","ok" );
                    } catch (Exception ex) {
                        wbo1.setAttribute("status", "fail");
                    }
                 out.write(Tools.getJSONObjectAsString(wbo1));

                break;
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
        return "Project Servlet";
    }

    @Override
    protected int getOpCode(String opName) {
        if (opName.equalsIgnoreCase("saveUnitAddonAjax")) {
            return 1;
        }
        if (opName.equalsIgnoreCase("deleteUnitAddonAjax")) {
            return 2;
        }

        return 0;
    }
}
