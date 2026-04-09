/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.silkworm.automation;

import com.clients.db_access.ClientProductMgr;
import com.clients.db_access.ReservationMgr;
import com.clients.db_access.ReservationNotificationMgr;
import com.crm.common.CRMConstants;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.common.UserMgr;
import com.tracker.db_access.IssueStatusMgr;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;
import java.util.logging.Level;
import org.apache.log4j.Logger;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

/**
 *
 * @author haytham
 */
public class ReservationAutomation implements Job {

    private final Logger logger;
    private final ReservationNotificationMgr notification;
    private final ReservationMgr reservationMgr;
    private final IssueStatusMgr statusMgr;
    private final SimpleDateFormat formatter;

    /**
     * <p>
     * Empty constructor for job initialization
     * </p>
     * <p>
     * Quartz requires a public empty constructor so that the scheduler can
     * instantiate the class whenever it needs.
     * </p>
     */
    public ReservationAutomation() {
        logger = Logger.getLogger(ReservationAutomation.class);
        notification = ReservationNotificationMgr.getInstance();
        reservationMgr = ReservationMgr.getInstance();
        statusMgr = IssueStatusMgr.getInstance();
        formatter = new SimpleDateFormat("yyyy-MM-dd");
    }

    /**
     * <p>
     * Called by the <code>{@link org.quartz.Scheduler}</code> when a
     * <code>{@link org.quartz.Trigger}</code> fires that is associated with the
     * <code>Job</code>.
     * </p>
     *
     * @param context
     * @throws JobExecutionException if there is an exception while executing
     * the job.
     */
    @Override
    public void execute(JobExecutionContext context) throws JobExecutionException {
        List<WebBusinessObject> reserveds = notification.getCanceledReservation();

        WebBusinessObject wbo;
        Calendar calendar = Calendar.getInstance();
        String reservedId;
        String unitId;
        logger.info(">>>>>>>>>>>>>>>>>>>>>>>> Cancel Reservation " + reserveds.size());

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        WebBusinessObject userWbo = UserMgr.getInstance().getOnSingleKey("-1");
        for (WebBusinessObject reserved : reserveds) {
            reservedId = (String) reserved.getAttribute("id");
            unitId = (String) reserved.getAttribute("unitId");

            wbo = new WebBusinessObject();
            wbo.setAttribute("statusCode", CRMConstants.RESERVATION_STATUS_CANCEL);
            wbo.setAttribute("date", formatter.format(calendar.getTime()));
            wbo.setAttribute("businessObjectId", reservedId);
            wbo.setAttribute("statusNote", "UL");
            wbo.setAttribute("objectType", "RESERVATION");
            wbo.setAttribute("parentId", "UL");
            wbo.setAttribute("issueTitle", "UL");
            wbo.setAttribute("cuseDescription", "UL");
            wbo.setAttribute("actionTaken", "Auto");
            wbo.setAttribute("preventionTaken", "UL");
            try {
                if (statusMgr.changeStatus(wbo) && reservationMgr.updateStatus(CRMConstants.RESERVATION_STATUS_CANCEL, reservedId)) {
                    WebBusinessObject statusWbo = new WebBusinessObject();
                    statusWbo.setAttribute("statusCode", "8");
                    statusWbo.setAttribute("date", sdf.format(Calendar.getInstance().getTime()));
                    statusWbo.setAttribute("businessObjectId", reserved.getAttribute("unitId"));
                    statusWbo.setAttribute("statusNote", "UL");
                    statusWbo.setAttribute("objectType", "Housing_Units");
                    statusWbo.setAttribute("parentId", "UL");
                    statusWbo.setAttribute("issueTitle", "UL");
                    statusWbo.setAttribute("cuseDescription", "UL");
                    statusWbo.setAttribute("actionTaken", "UL");
                    statusWbo.setAttribute("preventionTaken", "UL");
                    IssueStatusMgr.getInstance().changeStatus(statusWbo, userWbo, null);
                    ClientProductMgr.getInstance().deleteOnArbitraryDoubleKey((String) reserved.getAttribute("clientId"), "key1",
                            (String) reserved.getAttribute("unitId"), "key2");
                    wbo.setAttribute("status", "Ok");
                }
            } catch (SQLException ex) {
                logger.error(ex);
            } catch (Exception ex) {
                java.util.logging.Logger.getLogger(ReservationAutomation.class.getName()).log(Level.SEVERE, null, ex);
            }

            logger.info(">>>>>>>>>>>>>>>>>>>> Finish Cancelation Reserved Unit: " + unitId);
        }
    }
}
