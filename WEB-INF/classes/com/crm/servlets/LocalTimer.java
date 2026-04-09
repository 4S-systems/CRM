/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.crm.servlets;

import com.clients.db_access.ClientMgr;
import com.clients.servlets.ClientServlet;
import com.maintenance.common.ParseSideMenu;
import com.maintenance.db_access.TradeMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.common.MetaDataMgr;
import com.silkworm.common.UserClientsMgr;
import com.silkworm.common.UserMgr;
import com.silkworm.db_access.FileMgr;
import com.silkworm.servlets.MultipartRequest;
import com.tracker.servlets.TrackerBaseServlet;
import com.workFlowTasks.db_access.WFTaskDocMgr;
import java.awt.image.BufferedImage;
import java.io.BufferedInputStream;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.w3c.dom.Document;

/**
 *
 * @author Mahmoud
 */
public class LocalTimer extends TrackerBaseServlet {

    ClientMgr clientMgr = ClientMgr.getInstance();
    private String title;
    String op = null;
    String filterName = null;
    String filterValue = null;
    String categoryId = null;
    Vector unitsList = null;
    ArrayList unitArr;
    ArrayList itemCategory;
    String[] quantityMainType = {"", ""};
    String[] priceMainType = {"", ""};
    String[] idMainType = {"", ""};
    String[] itemIdMainType = {"", ""};
    String[] itemCost = {"", ""};
    protected MultipartRequest mpr = null;
    private String docImageFilePath = null;
    private String reqOp = null;
    private File usrDir = null;
    private String[] usrDirContents = null;
    private WebBusinessObject folder = null;
    private String folderID = null;
    private String docID = null;
    private WebBusinessObject document = null;
    private WFTaskDocMgr wFTaskDocMgr = WFTaskDocMgr.getInstance();
    private FileMgr fileMgr = FileMgr.getInstance();
    private int numFiles = 0;
    WebBusinessObject fileDescriptor = null;
    public String wfTaskId = null;
    public String docType = null;
    BufferedInputStream gifData = null;
    BufferedImage myImage = null;
    Document doc = null;
    Vector docsList = null;
    String randFileName = null;
    String randome = null;
    int len = 0;

    /**
     * Processes requests for both HTTP
     * <code>GET</code> and
     * <code>POST</code> methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        super.processRequest(request, response);
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        ParseSideMenu parseSideMenu = new ParseSideMenu();
        UserClientsMgr userClientsMgr = UserClientsMgr.getInstance();
        UserMgr userMgr = UserMgr.getInstance();
        TradeMgr tradeMgr = TradeMgr.getInstance();

        switch (operation) {
            case 1:
                servedPage = "/employee_agenda_details.jsp";
                request.setAttribute("page", servedPage);
                this.forward(servedPage, request, response);
                break;
            case 2:
                servedPage = "/manager_agenda_emg.jsp";
                request.setAttribute("page", servedPage);
                this.forward(servedPage, request, response);
                break;

        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);

    }

    /**
     * Handles the HTTP
     * <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

    protected int getOpCode(String opName) {
        if (opName.equals("refreshEmpPage")) {
            return 1;
        }
        if (opName.equals("refreshMgrPage")) {
            return 2;
        }

        return 0;
    }
}
