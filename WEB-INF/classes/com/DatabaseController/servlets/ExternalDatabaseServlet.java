package com.DatabaseController.servlets;

import com.DatabaseController.db_access.ExternalDatabaseMgr;
import com.clients.db_access.ClientMgr;
import com.silkworm.common.MetaDataMgr;
import com.silkworm.logger.db_access.LoggerMgr;
import com.silkworm.persistence.relational.NoSuchColumnException;
import com.tracker.servlets.TrackerBaseServlet;
import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class ExternalDatabaseServlet extends TrackerBaseServlet {

    MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
    LoggerMgr loggerMgr = LoggerMgr.getInstance();

    @Override
    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        super.processRequest(request, response);
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        operation = getOpCode((String) request.getParameter("op"));

        switch (operation) {
            case 1:
                servedPage = "/docs/external_db_reports/client_financial_report.jsp";
                String clientId = request.getParameter("clientId");
                ClientMgr clientMgr = ClientMgr.getInstance();
                ExternalDatabaseMgr externalDatabaseMgr = ExternalDatabaseMgr.getInstance();
                if (clientId != null) {
                    request.setAttribute("clientWbo", clientMgr.getOnSingleKey(clientId));
                    try {
                        request.setAttribute("clientFinancialList", externalDatabaseMgr.getClientFinancialReport(clientId.substring(1), clientId.substring(0, 1)));
                    } catch (SQLException ex) {
                        Logger.getLogger(ExternalDatabaseServlet.class.getName()).log(Level.SEVERE, null, ex);
                        request.setAttribute("connectionError", ex.getMessage());
                    } catch (NoSuchColumnException ex) {
                        Logger.getLogger(ExternalDatabaseServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
                request.setAttribute("page", servedPage);
                this.forward(servedPage, request, response);
                break;

            case 2:
//                servedPage = "/docs/database_controller/enter_schema_names_form.jsp";
//                this.forward(servedPage, request, response);
                break;

            default:
                logger.error("no oreration found ...");
        }
    }

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected int getOpCode(String opName) {
        if (opName.equalsIgnoreCase("viewClientFinancialReport")) {
            return 1;
//        } else if (opName.equalsIgnoreCase("getRecreateAllViewForm")) {
//            return 2;
        }
        return 0;
    }

}
