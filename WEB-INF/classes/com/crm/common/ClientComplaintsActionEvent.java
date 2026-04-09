/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.crm.common;

import com.clients.db_access.ClientComplaintsMgr;
import com.crm.db_access.AlertMgr;

/**
 *
 * @author walid
 */
public class ClientComplaintsActionEvent extends ActionEvent {

    private final AlertMgr alertMgr;

    protected ClientComplaintsActionEvent() {
        alertMgr = AlertMgr.getInstance();
    }

    @Override
    public boolean fire(String statusCode, String businessObjectId, String createdBy) {
        boolean checker = false;
        try {
            // update client complaint status
            checker = ClientComplaintsMgr.getInstance().updateCurrentStatus(businessObjectId, statusCode);

            // create notifications about closure or finish
            if (statusCode.equalsIgnoreCase(CRMConstants.CLIENT_COMPLAINT_STATUS_FINISHED) || statusCode.equalsIgnoreCase(CRMConstants.CLIENT_COMPLAINT_STATUS_CLOSED)) {
                if (CRMConstants.CLIENT_COMPLAINT_STATUS_CLOSED.equalsIgnoreCase(statusCode)) {
                    checker = alertMgr.saveObjectCloseTicket(businessObjectId, createdBy);
                } else {
                    checker = alertMgr.saveObjectFinishTicket(businessObjectId, createdBy);
                }

//                // try to update current owner client complaint by manager of created by
//                if (statusCode.equalsIgnoreCase(CRMConstants.CLIENT_COMPLAINT_STATUS_FINISHED)) {
//                    ClientComplaintsMgr.getInstance().changeCurrentOwnerToManager(businessObjectId, createdBy);
//                }
            }
        } catch (Exception ex) {
            System.err.println(ex);
        }
        return checker;
    }
}
