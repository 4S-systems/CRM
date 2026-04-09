/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.Iphone;

import com.clients.db_access.ClientComplaintsMgr;
import com.clients.db_access.ClientMgr;
import com.clients.db_access.CustomerGradesMgr;
import com.maintenance.common.DateParser;
import com.clients.db_access.ClientProductMgr;
import com.maintenance.common.ParseSideMenu;
import com.maintenance.common.Tools;
import com.maintenance.db_access.IssueByComplaintMgr;
import com.maintenance.db_access.TradeMgr;
import com.silkworm.Exceptions.NoUserInSessionException;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.common.MetaDataMgr;
import com.silkworm.common.UserMgr;
import com.silkworm.pagination.FilterCondition;
import com.silkworm.pagination.Operations;
import com.silkworm.persistence.relational.NoSuchColumnException;
import com.tracker.db_access.ClientStatusMgr;
import com.tracker.db_access.IssueMgr;
import com.tracker.db_access.ProjectMgr;
import com.tracker.servlets.SearchServlet;
import com.tracker.servlets.TrackerBaseServlet;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Hashtable;
import java.util.List;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Waled
 */
//@WebServlet(name = "ClientServlet", urlPatterns = {"/ClientServlet"})
public class IpadServlet extends HttpServlet {

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
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try {
            Class.forName("oracle.jdbc.OracleDriver");
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(IpadServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
        PrintWriter out = response.getWriter();
        Connection conn = null;
        
        
        try {
            conn = DriverManager.getConnection("jdbc:oracle:thin:@196.218.26.70:1521:cmmi", "crm", "crm");
        } catch (SQLException ex) {
            Logger.getLogger(IpadServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
        // @//machineName:port/SID,   userid,  password
        try {
            Statement stmt = conn.createStatement();
            try {
                ResultSet rset = stmt.executeQuery("select t.option_one,t.option_two from project t where t.location_type='RES-MODEL' and t.project_description='model A'");

                try {

                    out.println("<html>");
                    WebBusinessObject wbo = new WebBusinessObject();
                    while (rset.next()) {
                        System.out.println(rset.getString(1));   // Print col 1
                        System.out.println(rset.getString(2));   // Print col 1
//                        out.println("option1=" + rset.getString(1));
//                        out.println("option2=" + rset.getString(2));
                        wbo.setAttribute("option1", rset.getString(1));
                        wbo.setAttribute("option2", rset.getString(2));

                    }

                    out.write(Tools.getJSONObjectAsString(wbo));
                    out.println("</html>");
                } finally {
                    try {
                        rset.close();
                    } catch (Exception ignore) {
                    }
                }
            } finally {
                try {
                    stmt.close();
                } catch (Exception ignore) {
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(IpadServlet.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                conn.close();
            } catch (Exception ignore) {
            }
        }

    }
}