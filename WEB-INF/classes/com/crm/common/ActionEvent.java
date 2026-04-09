/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.crm.common;

/**
 *
 * @author walid
 */
public abstract class ActionEvent {
    public abstract boolean fire(String statusCode, String businessObjectId, String createdBy);
    
    public static ClientComplaintsActionEvent getClientComplaintsActionEvent() {
        return new ClientComplaintsActionEvent();
    }
}
