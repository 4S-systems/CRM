/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.silkworm.automation;

import com.maintenance.common.AutomationConfigurationMgr;
import com.maintenance.common.SenderConfiurationMgr;
import com.silkworm.common.MessagesMgr;
import com.silkworm.common.MetaDataMgr;
import com.silkworm.persistence.relational.UniqueIDGen;
import com.tracker.db_access.ProjectMgr;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Map;
import java.util.logging.Level;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import org.apache.log4j.Logger;

/**
 *
 * @author Waleed
 */
public class AutomationServlet extends HttpServlet {

    protected static Logger logger = Logger.getLogger(AutomationServlet.class);

    @Override
    public void init(ServletConfig cfg) throws javax.servlet.ServletException {
        super.init(cfg);
        MetaDataMgr dataMgr = MetaDataMgr.getInstance();
        AutomationConfigurationMgr configuration = AutomationConfigurationMgr.getCurrentInstance();
        SenderConfiurationMgr senderConfiurationMgr = SenderConfiurationMgr.getCurrentInstance();
        ProjectMgr projectMgr = ProjectMgr.getInstance();

        if ((dataMgr.getRunAutomationReports() != null) && (dataMgr.getRunAutomationReports().equalsIgnoreCase("1"))) {
            logger.info("Automation Servlet Started ....................");
            // auto change status for canceled reservations
            try {
                CustomScheduler scheduler = CustomScheduler.getInstance(ReservationAutomation.class, configuration.getReservationInterval());
                logger.info("Reservation Automatiot Started ....................");
                scheduler.run();
            } catch (Exception ex) {
                logger.error(ex);
            }
           
            // auto generate and send Not Acknowledge Report
//            try {
//                SenderConfiurationMgr confiuration = SenderConfiurationMgr.getCurrentInstance();
//                CustomScheduler scheduler = CustomScheduler.getInstance(AcknowledgeReport.class, confiuration.getIntervalEscalation());
//                scheduler.run();
//            } catch (Exception ex) {
//                logger.error(ex);
//            }

//
//            try {
//                // report to display Clients comments for all sales men
//                //SLS-1
//                SenderConfiurationMgr confiuration = SenderConfiurationMgr.getCurrentInstance();
//                CustomScheduler scheduler = CustomScheduler.getInstance(ClientByEmployeeDetailedReport.class, confiuration.getIntervalEscalation());
//                scheduler.run();
//            } catch (Exception ex) {
//                logger.error(ex);
//            }
//
//            try {
//                // report to display Clients comments for all sales men
//                //SLS-2
//                SenderConfiurationMgr confiuration = SenderConfiurationMgr.getCurrentInstance();
//                CustomScheduler scheduler = CustomScheduler.getInstance(ClientCommentsReport.class, confiuration.getIntervalEscalation());
//                scheduler.run();
//            } catch (Exception ex) {
//                logger.error(ex);
//            }
//
//            try {
//                // report to show sales evaluation (reservations-confirmations-appointments) 
//                //SLS-3
//                SenderConfiurationMgr confiuration = SenderConfiurationMgr.getCurrentInstance();
//                CustomScheduler scheduler = CustomScheduler.getInstance(ClientByEmployeeReport.class, confiuration.getIntervalEscalation());
//                scheduler.run();
//            } catch (Exception ex) {
//                logger.error(ex);
//            }
//
//            try {
//                // report to show sales evaluation (reservations-confirmations-appointments) 
//                //SLS-3
//                SenderConfiurationMgr confiuration = SenderConfiurationMgr.getCurrentInstance();
//                Class<ClientGreeting> test = ClientGreeting.class;
//                CustomScheduler scheduler = CustomScheduler.getInstance(test, confiuration.getIntervalEscalation());
//                scheduler.run();
//            } catch (Exception ex) {
//                logger.error(ex);
//            }
//
//             //Report of getting the first and second comments for a client
//             //QC1
//            try {
//                SenderConfiurationMgr confiuration = SenderConfiurationMgr.getCurrentInstance();
//                CustomScheduler scheduler = CustomScheduler.getInstance(CommentsReplyReport.class, confiuration.getIntervalEscalation());
//                scheduler.run();
//            } catch (Exception ex) {
//                logger.error(ex);
//            }
//
            // I think it is an Escalation Report
//            try {
//                SenderConfiurationMgr confiuration = SenderConfiurationMgr.getCurrentInstance();
//                CustomScheduler scheduler = CustomScheduler.getInstance(ClientsReport.class, 60 * confiuration.getIntervalEscalation());
//                scheduler.run();
//            } catch (Exception ex) {
//                logger.error(ex);
//            }

            // Delayed Complaints SLA Report sender
//            try {
//                NotificationScheduler notificationScheduler = NotificationScheduler.getInstance(NotificationJob.class, Long.parseLong(senderConfiurationMgr.getNotificationInterval()));
//                notificationScheduler.run();
//            } catch (Exception ex) {
//                logger.error(ex);
//            }
            // Compaint Email Sender
            try {
                CustomScheduler scheduler = CustomScheduler.getInstance(ComplaintNotificationJob.class, Long.parseLong(senderConfiurationMgr.getComplaintNotificationInterval()) * 60);
                scheduler.run();
            } catch (Exception ex) {
                logger.error(ex);
            }
        }
        // Auto close all finshed complaints with no action
        try {
            CustomScheduler scheduler = CustomScheduler.getInstance(QuartzClosedClinetComplaintsAutomation.class, configuration.getClosedClientComplaintsInterval());
            scheduler.run();
        } catch (Exception ex) {
            logger.error(ex);
        }
        // Auto Finish all finshed complaints with no action
        try {
            CustomScheduler scheduler = CustomScheduler.getInstance(QuartzFinishClientComplaintsAutomation.class, configuration.getClosedClientComplaintsInterval());
            scheduler.run();
        } catch (Exception ex) {
            logger.error(ex);
        }

        // auto closure for all QC Requests after accepted or refuesed by quality manager
        try {
            CustomScheduler scheduler;
            String id, objectId, objectCode;
            ArrayList<Map<String, String>> autoClosureDepartmentData = configuration.getAutoClosureDepartmentsData();
            for (Map departmentData : autoClosureDepartmentData) {

                int interval, closureInterval;
                String[] keys = new String[]{"departmentCode", "interval", "closureInterval", "actionID", "type"};
                Object[] values;
                if (departmentData.get("intervalValue") != null) {
                    id = UniqueIDGen.getNextID();
                    objectId = (String) departmentData.get("departmentID");
                    objectCode = projectMgr.getProjectCode(objectId);
                    interval = Integer.parseInt((String) departmentData.get("intervalValue"));
                    closureInterval = Integer.parseInt((String) departmentData.get("closureInterval"));

                    if ((objectCode != null) && (interval > 0)) {
                        values = new Object[]{objectCode, interval, closureInterval, departmentData.get("actionID"), departmentData.get("type")};

                        scheduler = CustomScheduler.getInstance(id, DepartmentClosedClinetComplaintsAutomation.class, interval * 60 * 60);
                        scheduler.init(keys, values);
                        scheduler.getScheduler().start();
                    }
                }
            }
        } catch (NumberFormatException ex) {

        } catch (Exception ex) {
            System.out.println("error -->> " + ex.getMessage());
        }

        try {
            CustomScheduler scheduler = CustomScheduler.getInstance(BatchQCJob.class, configuration.getBatchQCInterval() * 60);
            scheduler.run();
        } catch (Exception ex) {
            logger.error(ex);
        }

        try {
            CustomScheduler scheduler = CustomScheduler.getInstance(CallingPlanAutomation.class, configuration.getCallingPlanInterval() * 60);
            scheduler.run();
        } catch (Exception ex) {
            logger.error(ex);
        }

        try {
            CustomScheduler scheduler = CustomScheduler.getInstance(QualityPlanAutomation.class, configuration.getQualityPlanInterval() * 60);
            scheduler.run();
        } catch (Exception ex) {
            logger.error(ex);
        }

        if ("1".equals(dataMgr.getCheckAuthorization())) {
            try {
                CustomScheduler scheduler = CustomScheduler.getInstance(AuthorizationAutomation.class, configuration.getAuthorizationInterval() * 60);
                scheduler.run();
            } catch (Exception ex) {
                logger.error(ex);
            }
        }

        if ("1".equals(dataMgr.getRunSessionKill())) {
            try {
                CustomScheduler sessionKillScheduler = CustomScheduler.getInstance(SessionKill.class, configuration.getSessionKillInterval() * 60);
                logger.info("Session Kill Automation Started ....................");
                sessionKillScheduler.run();
            } catch (Exception ex) {
                java.util.logging.Logger.getLogger(AutomationServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        if (configuration.getContractNotifcationInterval() != 0) {
            try {
                CustomScheduler contractNotificationScheduler = CustomScheduler.getInstance(ContractExpireNotification.class, configuration.getContractNotifcationInterval() * 60);
                logger.info("Contract Expire Notification Started ....................");
                contractNotificationScheduler.run();
            } catch (Exception ex) {
                java.util.logging.Logger.getLogger(AutomationServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        if (configuration.getClosedAutoWithdrawInterval()!= 0) {
            try {
                CustomScheduler closedAutoWithdrawScheduler = CustomScheduler.getInstance(ClosedAutoWithdraw.class, configuration.getClosedAutoWithdrawInterval() * 60);
                logger.info("Closed Auto Withdraw Started ....................");
                closedAutoWithdrawScheduler.run();
            } catch (Exception ex) {
                java.util.logging.Logger.getLogger(AutomationServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        loadMessagesList(cfg.getServletContext());
        
        if (configuration.getInterLocalAutoUpdateInterval()!= 0) {
            try {
                CustomScheduler scheduler = CustomScheduler.getInstance(InterLocalAutoUpdate.class, configuration.getInterLocalAutoUpdateInterval() * 60);
                logger.info("International Local Client Auto Update Started ....................");
                scheduler.run();
            } catch (Exception ex) {
                java.util.logging.Logger.getLogger(AutomationServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        // close all clients
//                try {
//                      
//                  CustomScheduler   scheduler = CustomScheduler.getInstance(AutoFinishAllClients.class,60);
//                  scheduler.run();
//                    }
//       catch (Exception ex) {
//            logger.error(ex);
//          }
    }

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            /* TODO output your page here. You may use following sample code. */
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet AutomationServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AutomationServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        } finally {
            out.close();
        }
    }
    
    private void loadMessagesList(ServletContext servletContext) {
        MessagesMgr messagesMgr = MessagesMgr.getInstance();
        servletContext.setAttribute("messagesList", messagesMgr.getAllActiveMessages());
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
}
