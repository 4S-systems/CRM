package com.maintenance.common;

import java.util.Hashtable;
import java.util.*;

public class TranslatorJOStatus {
    private Hashtable statusValues = new Hashtable();
    private Hashtable joTypes = new Hashtable();
    
    public TranslatorJOStatus(){
        setJoStatus();
        setJoTypes();
    }
    
    private void setJoStatus(){
        
        statusValues.put("EnAssigned", "Assigned");
        statusValues.put("ArAssigned", "&#1578;&#1605; &#1573;&#1587;&#1606;&#1575;&#1583;&#1607;");
        
        statusValues.put("EnCanceled", "Canceled");
        statusValues.put("ArCanceled", "&#1605;&#1604;&#1594;&#1609;");
        
        statusValues.put("EnSchedule", "Schedule");
        statusValues.put("ArSchedule", "&#1605;&#1582;&#1591;&#1591;");
        
        statusValues.put("EnInprogress", "Inprogress");
        statusValues.put("ArInprogress", "&#1578;&#1581;&#1578; &#1575;&#1604;&#1578;&#1606;&#1601;&#1610;&#1584;");
        
        statusValues.put("EnReassigned", "Reassigned");
        statusValues.put("ArReassigned", "&#1571;&#1593;&#1575;&#1583;&#1607; &#1575;&#1604;&#1573;&#1587;&#1606;&#1575;&#1583;");
        
        statusValues.put("EnClosed", "Closed");
        statusValues.put("ArClosed", "&#1578;&#1605; &#1578;&#1606;&#1601;&#1610;&#1584;&#1607;");
        
        statusValues.put("EnRejected", "Rejected");
        statusValues.put("ArRejected", "&#1578;&#1581;&#1578; &#1575;&#1604;&#1605;&#1585;&#1575;&#1580;&#1593;&#1607;");
        
        statusValues.put("EnOnhold", "Onhold");
        statusValues.put("ArOnhold", "&#1605;&#1593;&#1604;&#1602;");
        
        statusValues.put("EnResolved", "Resolved");
        statusValues.put("ArResolved", "&#1578;&#1605; &#1578;&#1606;&#1601;&#1610;&#1584;&#1607;");
        
        statusValues.put("EnFinished","Finished");
        statusValues.put("ArFinished","&#1575;&#1606;&#1578;&#1607;&#1578;");
    }
    
    private void setJoTypes(){
        
        joTypes.put("EnManager", "Manager");
        joTypes.put("ArManager", "&#1571;&#1583;&#1575;&#1585;&#1609;");
        
        joTypes.put("EnElectrical", "Electrical");
        joTypes.put("ArElectrical", "&#1603;&#1607;&#1585;&#1576;&#1609;");
        
        joTypes.put("EnMechanical", "Mechanical");
        joTypes.put("ArMechanical", "&#1605;&#1610;&#1603;&#1575;&#1606;&#1610;&#1603;&#1609;");
        
        joTypes.put("EnCivil", "Civil");
        joTypes.put("ArCivil", "&#1605;&#1583;&#1606;&#1609;");
        
        joTypes.put("EnAssistance", "Assistance");
        joTypes.put("ArAssistance", "&#1605;&#1587;&#1575;&#1593;&#1583;");
        
        joTypes.put("EnCopmlex", "Copmlex");
        joTypes.put("ArCopmlex", "&#1605;&#1593;&#1602;&#1583;");
        
    }
    
    public Hashtable getJoStatus(){
        return statusValues;
    }
    
    public Hashtable getJoTypes(){
        return joTypes;
    }
    
}
