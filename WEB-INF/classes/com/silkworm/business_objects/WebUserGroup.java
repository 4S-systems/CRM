package com.silkworm.business_objects;

import com.silkworm.business_objects.WebBusinessObject;

public class WebUserGroup extends WebBusinessObject
{
    private String groupName = null;
    private String userId = null;
    private String userName = null;
    private String password = null;
    private String groupMenu = null;
    
    public WebUserGroup() 
    {
    }
    
    public void setGroupName(String gn)
    {
        groupName = gn;
    }
    
    public String getGroupName()
    {
        return (groupName!=null?groupName:null);
    }
    
    public void setUserID(String ui)
    {
        userId = ui;
    }
    
    public String getUserID()
    {
        return (userId!=null?userId:null);
    }
    
    public void setUserName(String un)
    {
        userName = un;
    }
    
    public String getUserName()
    {
        return (userName!=null?userName:null);
    }
    
    public void setPassword(String pw)
    {
        password = pw;
    }
    
    public String getPassword()
    {
        return (password!=null?password:null);
    }
    
    public void setGroupManu(String gm)
    {
        groupMenu = gm;
    }
    
    public String getGroupMenu()
    {
        return (groupMenu!=null?groupMenu:null);
    }
    
     public void printSelf()
    {
        System.out.println("Group Name: " + " " + groupName);
        System.out.println("User ID: " + userId);
        System.out.println("User Name: " + " " + userName);
        System.out.println("password: " + " " + password);
        System.out.println("Group Menu: " + " " + groupMenu);
        System.out.println("--------------------------------end User Group");
    }    
}
