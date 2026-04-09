package com.tracker.business_objects;

import com.silkworm.business_objects.WebBusinessObject;

public class WebIssueType extends WebBusinessObject
{
    private String sessionId = null;
    private String issueId = null;
    private String issueName = null;
    private String issueDesc = null;
    
    public WebIssueType() 
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
    
    public void setIssueID(String id) 
    {
        issueId = id;
    }
        
    public String getIssueId() 
    {
        return issueId;
    }
    
    public void setIssueName(String iName)
    {
        issueName=iName;  
    }    
    
    public String getIssueName()
    {
      return (issueName!=null?issueName:null);  
    }    
    
    public void setIssueDesc(String desc)
    {
        issueDesc = desc;
    }
    
    public String getIssueDesc()
    {
        return (issueDesc!=null?issueDesc:null);  
    }
    
    public void printSelf()
    {
        System.out.println("Issue Id: " + " " + issueId);
        System.out.println("Issue Name: " + issueName);
        System.out.println("Session Id: " + " " + sessionId);
        System.out.println("--------------------------------end issue");
    }
}
