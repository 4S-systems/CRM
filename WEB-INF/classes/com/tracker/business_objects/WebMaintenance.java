package com.tracker.business_objects;

import com.silkworm.business_objects.WebBusinessObject;

public class WebMaintenance extends WebBusinessObject
{
    private String sessionId = null;
    private String maintenanceId = null;
//    private String eqID = null;
    private String maintenanceName = null;
    private String maintenanceDesc = null;
    
    public WebMaintenance() 
    {
    }
    
    public void setSessionID(String id) 
    {
        sessionId = id;
    }
    
    public String getSessionID() 
    {
        return (sessionId!=null?sessionId:null);
    }
    
    public void setMaintenanceID(String id) 
    {
        maintenanceId = id;
    }
        
    public String getMaintenanceId() 
    {
        return maintenanceId;
    }
    
//    public void setEqID(String eqId) 
//    {
//        eqID = eqId;
//    }
//        
//    public String getEqId() 
//    {
//        return eqID;
//    }
    
    public void setMaintenanceName(String fName)
    {
        maintenanceName=fName;  
    }    
    
    public String getMaintenanceName()
    {
      return (maintenanceName!=null?maintenanceName:null);  
    }    
    
    public void setMaintenanceDesc(String desc)
    {
        maintenanceDesc = desc;
    }
    
    public String getMaintenanceDesc()
    {
        return (maintenanceDesc!=null?maintenanceDesc:null);  
    }
    
    public void printSelf()
    {
     System.out.println("Maintenance Id: " + " " + maintenanceId);
     System.out.println("Maintenance Name: " + maintenanceName);
     System.out.println("Session Id: " + " " + sessionId);
     System.out.println("--------------------------------end maintenance");
     
     
    }    
}
