package com.android;

import com.android.business_objects.LiteWebBusinessObject;
import com.android.db_access.AndroidDevicesMgr;
import com.android.db_access.AndroidLocationsMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.common.MetaDataMgr;
import com.tracker.servlets.TrackerBaseServlet;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class AndroidServlet extends TrackerBaseServlet {

    MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
    WebBusinessObject userObj = null;
    AndroidDevicesMgr deviceMgr = AndroidDevicesMgr.getInstance();
    AndroidLocationsMgr locationMgr = AndroidLocationsMgr.getInstance();

    @Override
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        super.processRequest(request, response);
        operation = getOpCode((String) request.getParameter("op"));
        switch (operation) {
            case 1: {
                List<LiteWebBusinessObject> deviceList = deviceMgr.getMsuOrWrkrDevice("wrkr");
                servedPage = "/docs/android/device_list.jsp";
                request.setAttribute("deviceList", deviceList);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            }
            case 2: {
                String deviceId = request.getParameter("deviceId");
                List<LiteWebBusinessObject> locations = locationMgr.getAllDeviceCordinates(deviceId);
                servedPage = "/docs/android/locations_list.jsp";
                request.setAttribute("locations", locations);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            }
            case 3: {
                String deviceId = request.getParameter("deviceId");
                List<LiteWebBusinessObject> locations = locationMgr.getAllDeviceCordinates(deviceId);
                servedPage = "/docs/android/locations_list2.jsp";
                request.setAttribute("locations", locations);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            }
        }
    }

    /**
     * Destroys the servlet.
     */
    @Override
    public void destroy() {
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
        return "Short description";
    }// </editor-fold>

    @Override
    protected int getOpCode(String opName) {
        if (opName.equalsIgnoreCase("listDevices")) {
            return 1;
        }
        if (opName.equalsIgnoreCase("location")) {
            return 2;
        }
        if (opName.equalsIgnoreCase("locationWithStatus")) {
            return 3;
        }
        return 0;
    }

}
