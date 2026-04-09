/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.wdr.servlets;

import com.clients.db_access.TradeTypeMgr;
import com.crm.common.CRMConstants;
import com.maintenance.db_access.RegionMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.tracker.servlets.TrackerBaseServlet;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Vector;
import javax.servlet.ServletConfig;
import oracle.ucp.jdbc.PoolDataSourceFactory;
import oracle.ucp.jdbc.PoolDataSource;

/**
 *
 * @author DynamicReports
 */
public class DReportsBaseServlet extends TrackerBaseServlet {

    private ServletConfig config = null;
    protected PoolDataSource pds;
    protected String dbase;
    protected String use_name;
    protected String pass_word;
    //  protected PoolDataSource pds; 

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    public void init(ServletConfig servletconfig)
            throws ServletException {
        config = servletconfig;

        init();

    }

    public void init()
            throws ServletException {

//     dbase = config.getInitParameter("dbase_url");
//        use_name = config.getInitParameter("user_name");
//         pass_word = config.getInitParameter("password");
//        
//        System.out.println("DReports Base Servlet " + dbase );
//         System.out.println("DReports Base Servlet " + use_name );
//          System.out.println("DReports Base Servlet " + pass_word );
//    
//    try
//  {
//   //Creating a pool-enabled data source
//   pds = PoolDataSourceFactory.getPoolDataSource();
//   //Setting connection properties of the data source
//   pds.setConnectionFactoryClassName("oracle.jdbc.pool.OracleDataSource");
//   pds.setURL(dbase);
//   pds.setUser(use_name);
//   pds.setPassword(pass_word);
//   //Setting pool properties
//   pds.setInitialPoolSize(5);
//   pds.setMinPoolSize(5);
//   pds.setMaxPoolSize(10);
//   //Borrowing a connection from the pool
//   Connection conn = pds.getConnection();
//   System.out.println("\nConnection borrowed from the pool");
//   //Checking the number of available and borrowed connections
//   int avlConnCount = pds.getAvailableConnectionsCount();
//   System.out.println("\nAvailable connections: " + avlConnCount);
//   int brwConnCount = pds.getBorrowedConnectionsCount();
//   System.out.println("\nBorrowed connections: " + brwConnCount);
//   //Working with the connection
//   Statement stmt = conn.createStatement();
//   ResultSet rs = stmt.executeQuery("select user from dual");
//   while(rs.next())
//    System.out.println("\nConnected as: "+rs.getString(1));
//   rs.close();
//   //Returning the connection to the pool
//   conn.close();
//   conn=null;
//   System.out.println("\nConnection returned to the pool");
//   //Checking the number of available and borrowed connections again
//   avlConnCount = pds.getAvailableConnectionsCount();
//   System.out.println("\nAvailable connections: " + avlConnCount);
//   brwConnCount = pds.getBorrowedConnectionsCount();
//   System.out.println("\nBorrowed connections: " + brwConnCount);
//  }
//  catch(SQLException e)
//  {
//   System.out.println("\nAn SQL exception occurred : " + e.getMessage());
//  }
// 
//    
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        super.processRequest(request, response);
        response.setContentType("text/html;charset=UTF-8");

        switch (operation) {
            case 1:
            System.out.println("YARAB");
                break;

        }
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
            throws ServletException, IOException {
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
        if (opName.equals("GetTestReport")) {
            return 1;
        }
        return 0;
    }

}
