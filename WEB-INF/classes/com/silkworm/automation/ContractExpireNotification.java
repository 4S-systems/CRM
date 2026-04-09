package com.silkworm.automation;

import com.android.business_objects.LiteWebBusinessObject;
import com.businessfw.oms.db_access.ContractMgr;
import com.crm.common.CRMConstants;
import com.crm.db_access.AlertMgr;

import java.util.ArrayList;
import java.util.logging.Level;
import org.apache.log4j.Logger;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

public class ContractExpireNotification implements Job {

    private static final Logger logger = Logger.getLogger(ContractExpireNotification.class);

    public ContractExpireNotification() {
    }

    @Override
    public void execute(JobExecutionContext context) throws JobExecutionException {
        logger.info("--------------------------- Starting Contract Expire Notification ---------------------------");
        System.out.println("--------------------------- Starting Contract Expire Notification ---------------------------");
        ArrayList<LiteWebBusinessObject> contractsList = ContractMgr.getInstance().getAllContractsAboutToExpire(30);
        AlertMgr alertMgr = AlertMgr.getInstance();
        String contractID, alertType, message = "Contract Expired";
        boolean isExists;
        for (LiteWebBusinessObject contractWbo : contractsList) {
            contractID = (String) contractWbo.getAttribute("id");
            alertType = CRMConstants.ALERT_TYPE_ID_CONTRACT_EXPIRE;
            isExists = alertMgr.alreadyExists(contractID, alertType, "contract");
            if (!isExists) {
                try {
                    alertMgr.saveObject(contractID, alertType, CRMConstants.SYSTEM_AUTOMATION_ID, message, "contract");
                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(ContractExpireNotification.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
            logger.info(">>>>>>>>>>>>>>>>>>>> Finish Notify Contract: " + contractID);
        }
    }
}
