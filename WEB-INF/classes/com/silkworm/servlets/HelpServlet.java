/*
 * HelpServlet.java
 *
 * Created on April 30, 2004, 7:58 AM
 */
package com.silkworm.servlets;

import com.silkworm.Exceptions.UbnormalProcessTerminationEx;
import java.io.*;

import javax.servlet.*;
import javax.servlet.http.*;
import com.silkworm.common.TimeServices;
import com.silkworm.util.*;
import com.silkworm.common.*;

/**
 *
 * @author walid
 * @version
 */
public class HelpServlet extends swBaseServlet {

    /**
     * Initializes the servlet.
     */
    private String fileName = null;
    private MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    private ApplicationSessionRegistery appRegistry = ApplicationSessionRegistery.getInstance();

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        fileName = metaMgr.getBackupDir() + "bup" + TimeServices.getCurrentDay() + TimeServices.getCurrentMonth() + TimeServices.getCurrentYear();
    }

    /**
     * Destroys the servlet.
     */
    @Override
    public void destroy() {

    }

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws javax.servlet.ServletException
     * @throws java.io.IOException
     */
    @Override
    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String helpPage = request.getParameter("help");

        super.processRequest(request, response);
        operation = getOpCode((String) request.getParameter("op"));

        switch (operation) {

            case 1:
                request.setAttribute("page", "/docs/help/splash.jsp");
                forwardToServedPage(request, response);
                break;

            case 2:
                request.setAttribute("page", "/docs/help/" + helpPage);
                forwardToServedPage(request, response);
                break;

            case 3:
                ServletOutputStream soundStream = null;
                BufferedInputStream soundBuffer = null;
                try {
                    soundStream = response.getOutputStream();
                    File soundFile = new File(web_inf_path + "/" + "presentation.wav");
                    response.setContentType("audio/mpeg");
                    response.addHeader("Content-Disposition", "attachment; filename=" + "presentation.wav");
                    response.setContentLength((int) soundFile.length());
                    FileInputStream input = new FileInputStream(soundFile);
                    soundBuffer = new BufferedInputStream(input);
                    int readBytes;
                    while ((readBytes = soundBuffer.read()) != -1) {
                        soundStream.write(readBytes);
                    }
                } catch (IOException ioe) {
                    throw new ServletException(ioe.getMessage());
                } finally {
                    if (soundStream != null) {
                        soundStream.close();
                    }
                    if (soundBuffer != null) {
                        soundBuffer.close();
                    }
                }
                break;

            case 4:
                request.setAttribute("page", "/docs/help/security.jsp");
                forwardToServedPage(request, response);
                break;

            case 5:
                request.setAttribute("path", fileName);
                request.setAttribute("page", "/docs/Adminstration/backup.jsp");
                forwardToServedPage(request, response);
                break;

            case 6:
                request.setAttribute("page", "/docs/Adminstration/backup.jsp");
                StringBuilder command = new StringBuilder("cmd /c jar -cvf ");
                command.append(fileName).append(".jar c:\\mySQL\\data\\arabic\\*.*");
                try {
                    Fork.runCommand(command.toString());
                    request.setAttribute("path", fileName);
                    request.setAttribute("status", "Backup completed");
                } catch (InterruptedException e) {
                    request.setAttribute("status", "Backup failed");
                } catch (IOException e) {
                    request.setAttribute("status", "Backup failed");
                } catch (UbnormalProcessTerminationEx e) {
                    request.setAttribute("status", "Backup failed");
                }
                forwardToServedPage(request, response);
                break;

            case 7:
                request.setAttribute("page", "/docs/Adminstration/under_construction.jsp");
                forwardToServedPage(request, response);
                break;

            default:
                break;
        }

    }

    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws javax.servlet.ServletException
     * @throws java.io.IOException
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws javax.servlet.ServletException
     * @throws java.io.IOException
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return
     */
    @Override
    public String getServletInfo() {
        return "Help Servlet";
    }

    /**
     *
     * @param opName
     * @return
     */
    @Override
    protected int getOpCode(String opName) {
        if (opName.equalsIgnoreCase("Splash")) {
            return 1;
        }

        if (opName.equalsIgnoreCase("ThisFile")) {
            return 2;
        }

        if (opName.equalsIgnoreCase("AudioPresentation")) {
            return 3;
        }

        if (opName.equalsIgnoreCase("Security")) {
            return 4;
        }

        if (opName.equalsIgnoreCase("BackupDatabase")) {
            return 5;
        }

        if (opName.equalsIgnoreCase("StartBup")) {
            return 6;
        }

        if (opName.equalsIgnoreCase("Help")) {
            return 7;
        }

        return 0;
    }
}
