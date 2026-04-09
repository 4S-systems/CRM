package com.tracker.business_objects;

import com.silkworm.business_objects.WebBusinessObject;



public class WebUrgency extends WebBusinessObject
{
    private String urgencyId = null;
    private String urgencyName = null;
    private String urgencyDesc = null;
    
    public WebUrgency() 
    {
    }
    
    public void setUrgencyID(String id) 
    {
        urgencyId = id;
    }
        
    public String getUrgencyId() 
    {
        return urgencyId;
    }
    
    public void setUrgencyName(String uName)
    {
        urgencyName=uName;  
    }    
    
    public String getUrgencyName()
    {
      return (urgencyName!=null?urgencyName:null);  
    }
    
    public void setUrgencyDesc(String uDesc)
    {
        urgencyDesc=uDesc;  
    }    
    
    public String getUrgencyDesc()
    {
      return (urgencyDesc!=null?urgencyDesc:null);  
    }
    
    public void printSelf()
    {
        System.out.println("Urgency Id: " + " " + urgencyId);
        System.out.println("Urgency Name: " + urgencyName);
        System.out.println("Uregency Desc: "+urgencyDesc);
        System.out.println("--------------------------------end urgency");
    }    
}
