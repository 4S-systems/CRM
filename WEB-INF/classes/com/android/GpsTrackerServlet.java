package com.android;

import com.android.db_access.AndroidDevicesMgr;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.OutputStreamWriter;
import java.net.URLDecoder;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class GpsTrackerServlet extends HttpServlet
{

    int operation;
    AndroidDevicesMgr androidDeviceMgr = AndroidDevicesMgr.getInstance();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
        response.setContentType("text/html;charset=UTF-8");
        operation = getOpCode((String) request.getParameter("op"));
        switch (operation)
        {
            case 1:
            {
                OutputStreamWriter out = new OutputStreamWriter(response.getOutputStream(), "UTF-8");
                String mac = request.getParameter("mac");
                String result = androidDeviceMgr.RegesterDivce(mac);
                out.write(result);
                out.close();
                break;
            }
            case 2:
            {
                OutputStreamWriter out = new OutputStreamWriter(response.getOutputStream(), "UTF-8");
                String lat = request.getParameter("lat");
                String lng = request.getParameter("lng");
                String mac = request.getParameter("mac");
                String address = request.getParameter("address");
                String state = request.getParameter("status");
                boolean result = true;
                if (state != null)
                {
                    result = androidDeviceMgr.UpdateLocationWithStatus(lat, lng, mac, address, state);
                }
                else
                {
                    result = androidDeviceMgr.UpdateLocation(lat, lng, mac, address);
                }
                if (result == true)
                {
                    out.write("success");
                }
                else
                {
                    out.write("fail");
                }
                out.close();
                break;
            }

            case 3:
            {
                OutputStreamWriter out = new OutputStreamWriter(response.getOutputStream(),"UTF-8");
                out.write("success");
                out.close();
                break;
            }
        }

    }

    protected int getOpCode(String opName)
    {
        if (opName.equals("registerDevice"))
        {
            return 1;
        }
        if (opName.equals("updateLocation"))
        {
            return 2;
        }
        if (opName.equals("testConnection"))
        {
            return 3;
        }
        return 0;
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo()
    {
        return "Short description";
    }// </editor-fold>

}
