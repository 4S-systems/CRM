package com.callcenter.servlets;

import com.callcenter.util.SambaReadingUtil;
import com.clients.db_access.ClientMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.tracker.servlets.TrackerBaseServlet;
import java.io.IOException;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class CallCenterServlet extends TrackerBaseServlet {

    @Override
    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        super.processRequest(request, response);

        switch (operation) {
            case 1:
                ClientMgr clientMgr = ClientMgr.getInstance();
                servedPage = "/docs/call_center/view_out_calls.jsp";
                SambaReadingUtil sambaReadingUtil = new SambaReadingUtil();
                ArrayList<String> files = sambaReadingUtil.getOutFileList();
                WebBusinessObject callWbo;
                SimpleDateFormat sdf;
                ArrayList<WebBusinessObject> callsList = new ArrayList<>();
                for (String fileName : files) {
                    String[] arrFile = fileName.split("_");
                    System.out.println("Mobile Number ---->>> " + arrFile[0]);
                    try {
                        ArrayList<WebBusinessObject> clientsTempList = new ArrayList<>(clientMgr.getOnArbitraryKeyOracle(arrFile[0], "key4"));
                        if (clientsTempList.isEmpty()) {
                            callWbo = new WebBusinessObject();
                            callWbo.setAttribute("name", "لا يوجد");
                            callWbo.setAttribute("mobile", arrFile[0]);
                        } else {
                            callWbo = clientsTempList.get(0);
                        }
                        sdf = new SimpleDateFormat("ddMMyyyy-HH-mm");
                        Date d = sdf.parse(arrFile[1]);
                        sdf = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
                        callWbo.setAttribute("callDate", sdf.format(d));
                        ArrayList<WebBusinessObject> usersTempList = new ArrayList<>(userMgr.getOnArbitraryKeyOracle(arrFile[2], "key4"));
                        if (usersTempList.isEmpty()) {
                            callWbo.setAttribute("userName", arrFile[2]);
                        } else {
                            callWbo.setAttribute("userName", usersTempList.get(0).getAttribute("fullName"));
                            callWbo.setAttribute("userId", usersTempList.get(0).getAttribute("userId"));
                        }
                        callWbo.setAttribute("fileName", fileName);
                        callsList.add(callWbo);
                    } catch (Exception ex) {
                        Logger.getLogger(CallCenterServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
                request.setAttribute("callsList", callsList);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 2:
                ServletOutputStream stream = null;
                sambaReadingUtil = new SambaReadingUtil();
                InputStream pdfData = sambaReadingUtil.getFile(request.getParameter("fileName"));
                try {
                    stream = response.getOutputStream();
                    response.setContentType("audio/wav");
                    response.setHeader("Content-Disposition", "attachment;filename=" + request.getParameter("mobile") + ".wav");
                    response.setHeader("Pragma", "private");
                    response.setHeader("Cache-Control", "private, must-revalidate");
                    response.setHeader("Accept-Ranges", "bytes");
                    int readBytes;
                    byte[] buf = new byte[1024];
                    while ((readBytes = pdfData.read(buf)) != -1) {
                        stream.write(buf,0, readBytes);
                    }
                } catch (IOException ioe) {
                    throw new ServletException(ioe.getMessage());
                } finally {
                    if (stream != null) {
                        stream.close();
                    }
                    if (pdfData != null) {
                        pdfData.close();
                    }
                }
                break;
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Call Center Servlet";
    }

    @Override
    protected int getOpCode(String opName) {
        if (opName.equals("getOutCallCenter")) {
            return 1;
        }
        if (opName.equals("playFile")) {
            return 2;
        }
        return 0;
    }
}
