package com.silkworm.automation;

import com.maintenance.db_access.ClientApplication;
import com.maintenance.db_access.TradeTempMgr;
import com.maintenance.db_access.WebServiceMgr;
import com.silkworm.business_objects.WebBusinessObject;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

public class AuthorizationAutomation implements Job {

    WebServiceMgr webServiceMgr;

    public AuthorizationAutomation() {
        webServiceMgr = WebServiceMgr.getInstance();
    }

    @Override
    public void execute(JobExecutionContext jec) throws JobExecutionException {
        TradeTempMgr tradeTempMgr = TradeTempMgr.getInstance();
        ClientApplication clientApplication = webServiceMgr.getClientAuthorityByWebService("ip/crm");
        WebBusinessObject wbo = tradeTempMgr.getOnSingleKey("1");
        boolean isExists = wbo != null;
        if (clientApplication != null && clientApplication.getId() != null) {
            if (!isExists) {
                wbo = new WebBusinessObject();
                wbo.setAttribute("id", "1");
            }
            wbo.setAttribute("isAuthorized", clientApplication.isIsAuthorized() ? "1" : "0");
            wbo.setAttribute("isPaid", clientApplication.isIsPaid() ? "1" : "0");
            wbo.setAttribute("isLocked", clientApplication.isIsLocked() ? "1" : "0");
            wbo.setAttribute("option4", "UL");
            wbo.setAttribute("option5", "UL");
            try {
                if (isExists) {
                    tradeTempMgr.updateObject(wbo);
                } else {
                    tradeTempMgr.saveObject(wbo);
                }
            } catch (SQLException ex) {
                Logger.getLogger(AuthorizationAutomation.class.getName()).log(Level.SEVERE, null, ex);
            }
        } else {
            tradeTempMgr.deleteOnSingleKey("1");
        }
    }

}
