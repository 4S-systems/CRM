package com.tracker.business_objects;

import com.silkworm.business_objects.WebBusinessObject;
import com.tracker.engine.AssignedIssueState;
import com.tracker.engine.IssueStatusFactory;
import java.util.*;
import com.tracker.common.*;

import com.silkworm.common.*;

public class WebIssue extends WebBusinessObject {
    
    private String id = null;
    private String faId = null;
    private String pid = null;
    private String issueId = null;
    private String userId = null;
    private String filterBack = null;
    private String urgencyId = null;
    private String isRisk = null;
    private String issueDesc = null;
    private String currentStatus = null;
    private String issueTitle = null;
    private String projectName = null;
    
    ////////////////////////////////////////////
    private Date expectedBeginDate=null;
    private Date expectedEndDate=null;
    private String docBaseUrl = null;
    private String docRefId = null;
    //////////////////////////////////////////////
    private String assignedToID = null;
    private String assignedToName = null;
    private String assignedByID = null;
    private String assignedByName = null;
    
    private Integer finishedTime = null;
    private String managerNote  = null;
    
    protected String filterName = null;
    protected String filterValue = null;
    // aggregates
    
    private AssignedIssueState ais = null;
    private WebBusinessObject bookmark = null;
    
    private String ownerId = null;
    private String sysUserId = null;
    
    private boolean isUserOwner = false;
    
    private String denyStateAccess = null;
    
    protected String  context = null;
    
    public WebIssue() {
    }
    
    public WebIssue(Hashtable ht) {
        super(ht);
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        // tGuide = new TouristGuide("/com/docviewer/international/DocOnlineMenu");
        
        context= metaMgr.getContext();
        
        
        
    }
    
    
    
    public void setOwnerId(String id) {
        ownerId = id;
        
    }
    
    public boolean isTerminal() {
        return ais.isTerminal();
    }
    
    public void setSysUserId(String id) {
        sysUserId = id;
        
    }
    
    public void setViewrsIds(String ownerId,String sysUserId) {
        this.ownerId = ownerId;
        this.sysUserId = sysUserId;
        
        if(ownerId.equals(sysUserId)){
            isUserOwner = true;
        }
    }
    
    public boolean isUserOwner() {
        
        webUserGroup = new String((String) webUser.getAttribute("groupName"));
        isUserOwner = true;
//        if(ais.getStateName().equalsIgnoreCase("Schedule") || ais.getStateName().equalsIgnoreCase("Rejected") || ais.getStateName().equalsIgnoreCase("Resolved") || ais.getStateName().equalsIgnoreCase("Finished") || ais.getStateName().equalsIgnoreCase("Canceled"))
//        {
//            if(webUserGroup.equalsIgnoreCase("administrator"))
//            {
//                System.out.println("&&&&&&&&&&&&&&&&&&&&&&&& true");
//                isUserOwner = true;
//            } else
//            {
//                System.out.println("&&&&&&&&&&&&&&&&&&&&&&&& false");
//                isUserOwner = false;
//            }
//        }
//        if(!webUserGroup.equalsIgnoreCase("administrator") && ais.getStateName().equalsIgnoreCase("Unassigned"))
//            return false;
//        
//        if(ais.getStateName().equalsIgnoreCase("Unassigned") || ais.getStateName().equalsIgnoreCase("Rejected")) {
//            isUserOwner = true;
//        }
//        
//        
//        else if(super.webUserGroup.equalsIgnoreCase("administrator") && ais.getStateName().equalsIgnoreCase("Resolved"))
//        {
//            isUserOwner = true;
//        }
//        else
//        {
//            isUserOwner = isUserOwner;
//        }   
        
        
        return isUserOwner;
    }
    
    public AssignedIssueState getIssueStateObject() {
        
        return ais;
    }
    
    public void setIssueStateObject(AssignedIssueState stateObject) {
        ais = stateObject;
        
    }
    
    
    public void setIssueStateObject(WebIssue issue) {
        ais = IssueStatusFactory.getStateClass(this.getCurrentStatus(),issue);
        
    }
    
    
    
    public void setID(String issid) {
        id = issid;
    }
    
    public String getID() {
        return (id!=null?id:null);
    }
    
    public String getIssueTitle() {
        return (issueTitle!=null?issueTitle:null);
    }
    
    public void setIssueTitle(String title) {
        issueTitle = title;
    }
    
    
    public void setFAID(String fId) {
        faId = fId;
    }
    
    public String getFAID() {
        return (faId!=null?faId:null);
    }
    
    public void setIssueID(String issid) {
        issueId = issid;
    }
    
    public String getIssueID() {
        return (issueId!=null?issueId:null);
    }
    ////////////////////////////////////////////////////////////////////
//    public void setDocBaseUrl(String docbaseurl) {
//        docBaseUrl = docbaseurl;
//    }
//    
//    public String getDocBaseUrl() {
//        return (docBaseUrl!=null?docBaseUrl:null);
//    }
//    
//    public void setDocRefId(String docrefid) {
//        docRefId = docrefid;
//    }
//    
//    public String getDocRefId() {
//        return (docRefId!=null?docRefId:null);
//    }
    
    /////////////////////////////////////////////////////////////////////////
    public void setUserID(String uID) {
        userId = uID;
    }
    
    public String getUserID() {
        return (userId!=null?userId:null);
    }
    
    public void setUrgencyID(String uID) {
        urgencyId = uID;
    }
    
    public String getUrgencyID() {
        return (urgencyId!=null?urgencyId:null);
    }
    
     public void setIsRisk(String risk) {
        isRisk = risk;
    }
    
    public String getIsRisk() {
        return (isRisk!=null?isRisk:null);
    }
    
       
    public void setIssueDesc(String desc) {
        issueDesc = desc;
    }
    
    public String getIssueDesc() {
        return (issueDesc!=null?issueDesc:null);
    }
    
    public String getCurrentStatus() {
        return (String) this.getAttribute("currentStatus");
    }
    
    public void printState() {
        ais.printSelf();
    }
    
    public String getNextStateName() {
        return ais.getNextStateName();
    }
    
    public String getReverseStateName() {
        return ais.getReverseStateName();
    }
    
    public String getNextStateAction() {
        return ais.getNextStateAction();
    }
    
    public String getReverseStateAction() {
        return ais.getReverseStateAction();
    }
    
    public String getNextStateLink() {
        
        if(isUserOwner){// || ais.getStateName().equalsIgnoreCase(IssueStatusFactory.UNASSIGNED) || ais.getStateName().equalsIgnoreCase(IssueStatusFactory.REJECTED)){
            //String issueId = (String) this.getAttribute("id");
            System.out.println("LLLLLLLIIIIIIIINNNNNNNNKKKKKKKKK");
            System.out.println("VIEWORIGIN ------------------- "+ viewOrigin);
            viewOrigin.printSelf();
            
            String link =  ais.getNextStateLink() + "&filterName=" + (String) viewOrigin.getAttribute("filter") +"&filterValue=" + viewOrigin.getAttribute("filterValue");
            System.out.println("link servlet --------------------------"+ ais.getNextStateLink());
            System.out.println("link servlet---------------------------"+ link);
            return link;
        } else {
            
            return  denyStateAccess;
        }
    }
    
     public String getNextStateLink(String projectname) {
        
        if(isUserOwner || ais.getStateName().equalsIgnoreCase(IssueStatusFactory.SCHEDULE) || ais.getStateName().equalsIgnoreCase(IssueStatusFactory.REJECTED)){
            //String issueId = (String) this.getAttribute("id");
            System.out.println("LLLLLLLIIIIIIIINNNNNNNNKKKKKKKKK");
            System.out.println("VIEWORIGIN ------------------- "+ viewOrigin);
            viewOrigin.printSelf();
         
            String link =  ais.getNextStateLink() + "&filterName=" + (String) viewOrigin.getAttribute("filter") +"&filterValue=" + viewOrigin.getAttribute("filterValue") + "&projectName=" + projectname;
            System.out.println("link servlet --------------------------"+ ais.getNextStateLink());
            System.out.println("link servlet---------------------------"+ link);
            return link;
        } else {
            
            return  denyStateAccess;
        }
    }
    
    public String getBookmarkLink() {
        String issueId = (String) this.getAttribute("id");
        String issueTitle = (String) this.getAttribute("issueTitle");
        String issueState = getState();
        
        if(issueTitle==null) {
            issueTitle = "No Title";
        }
        
        filterValue = (String) viewOrigin.getAttribute("filterValue");
        filterName = (String) viewOrigin.getAttribute("filter");
        
        return context + "/BookmarkServlet?op=togol&issueId=" + issueId + "&issueTitle=" + issueTitle + "&issueState=" + issueState +  "&filterValue=" + filterValue + "&filterName=" + filterName;
    }
    
     public String getBookmarkLink(String projectname) {
        String issueId = (String) this.getAttribute("id");
        String issueTitle = (String) this.getAttribute("issueTitle");
        String issueState = getState();
        
        if(issueTitle==null) {
            issueTitle = "No Title";
        }
        filterValue = (String) viewOrigin.getAttribute("filterValue");
        filterName = (String) viewOrigin.getAttribute("filter");
        
        return context + "/BookmarkServlet?op=togol&issueId=" + issueId + "&issueTitle=" + issueTitle + "&issueState=" + issueState +  "&filterValue=" + filterValue + "&filterName=" + filterName + "&projectName=" + projectname;
    }
    
    public String getUndoBookmarkLink() {
        filterValue = (String) viewOrigin.getAttribute("filterValue");
        filterName = (String) viewOrigin.getAttribute("filter");
        
        return context + "/BookmarkServlet?op=delete&key=" + this.getBookmarkId() + "&issueState=" + getState()+"&viewOrigin=" +  "&filterValue=" + filterValue + "&filterName=" + filterName;
    }
    
     public String getUndoBookmarkLink(String projectname) {
        filterValue = (String) viewOrigin.getAttribute("filterValue");
        filterName = (String) viewOrigin.getAttribute("filter");
        
        return context + "/BookmarkServlet?op=delete&key=" + this.getBookmarkId() + "&issueState=" + getState()+"&viewOrigin=" +  "&filterValue=" + filterValue + "&filterName=" + filterName + "&projectName=" + projectname;
    }
     
     public String getUndoBookmarkRiskLink() {
        filterValue = (String) viewOrigin.getAttribute("filterValue");
        filterName = (String) viewOrigin.getAttribute("filter");
        
        return context + "/BookmarkServlet?op=delete&key=" + this.getBookmarkId() + "&issueState=" + getState()+"&viewOrigin=" +  "&filterValue=" + filterValue + "&filterName=Risk";
    }
    
    public String getViewBookmarkLink() {
        filterValue = (String) viewOrigin.getAttribute("filterValue");
        filterName = (String) viewOrigin.getAttribute("filter");
        
        return context + "/BookmarkServlet?op=view&key=" + this.getBookmarkId() + "&issueState=" + getState()+"&viewOrigin=" +  "&filterValue=" + filterValue + "&filterName=" + filterName;
    }
    
     public String getViewBookmarkLink(String projectname) {
        filterValue = (String) viewOrigin.getAttribute("filterValue");
        filterName = (String) viewOrigin.getAttribute("filter");
        
        return context + "/BookmarkServlet?op=view&key=" + this.getBookmarkId() + "&issueState=" + getState()+"&viewOrigin=" +  "&filterValue=" + filterValue + "&filterName=" + filterName + "&projectName=" + projectname;
    }
    
    public void setBookmark(WebBusinessObject bm) {
        
        bookmark = bm;
    }
    
    public boolean isBookmarked() {
        return (bookmark!=null?true:false);
        
    }
    
    public String getBookmarkId() {
        if(bookmark!=null) {
            return (String) bookmark.getAttribute("bookmarkId");
        }
        
        return null;
    }
    
    public String getReverseStateLink() {
        String link =  ais.getReverseStateLink() + "&filterName=" + (String) viewOrigin.getAttribute("filter") +"&filterValue=" + viewOrigin.getAttribute("filterValue");
        if(isUserOwner){// || ais.getStateName().equalsIgnoreCase(IssueStatusFactory.UNASSIGNED) || ais.getStateName().equalsIgnoreCase(IssueStatusFactory.REJECTED)) {
            //   return ais.getReverseStateLink();
            return link;
        } else {
            return denyStateAccess;
        }
    }
    
     public String getReverseStateLink(String projectname) {
        String link =  ais.getReverseStateLink() + "&filterName=" + (String) viewOrigin.getAttribute("filter") +"&filterValue=" + viewOrigin.getAttribute("filterValue") + "&projectName=" + projectname;
        if(isUserOwner || ais.getStateName().equalsIgnoreCase(IssueStatusFactory.SCHEDULE) || ais.getStateName().equalsIgnoreCase(IssueStatusFactory.REJECTED)) {
            //   return ais.getReverseStateLink();
            return link;
        } else {
            return denyStateAccess;
        }
    }
     
      public String getReverseStateRiskLink(String filterValue) {
        String link =  ais.getReverseStateLink() + "&filterName=RiskReport&filterValue=" + filterValue;
        if(isUserOwner || ais.getStateName().equalsIgnoreCase(IssueStatusFactory.SCHEDULE) || ais.getStateName().equalsIgnoreCase(IssueStatusFactory.REJECTED)) {
            //   return ais.getReverseStateLink();
            return link;
        } else {
            denyStateAccess = context + "/SecurityServlet?op=" + AppConstants.NOT_ISSUE_OWENER + "&issueState=" + ais.getStateName() + "&filterName=RiskReport&filterValue=" + filterValue;
            return denyStateAccess;
        }
    }
      
      public String getReverseStateRiskLink(String filterValue,String projectname) {
        String link =  ais.getReverseStateLink() + "&filterName=RiskReport&filterValue=" + filterValue;
        if(isUserOwner || ais.getStateName().equalsIgnoreCase(IssueStatusFactory.SCHEDULE) || ais.getStateName().equalsIgnoreCase(IssueStatusFactory.REJECTED)) {
            //   return ais.getReverseStateLink();
            return link;
        } else {
            denyStateAccess = context + "/SecurityServlet?op=" + AppConstants.NOT_ISSUE_OWENER + "&issueState=" + ais.getStateName() + "&filterName=RiskReport&filterValue=" + filterValue + "&projectName=" + projectname;
            return denyStateAccess;
        }
    }
      
      public String getNextStateRiskLink(String filterValue) {
        
        if(isUserOwner || ais.getStateName().equalsIgnoreCase(IssueStatusFactory.SCHEDULE) || ais.getStateName().equalsIgnoreCase(IssueStatusFactory.REJECTED)){         
            String link =  ais.getNextStateLink() + "&filterName=RiskReport&filterValue=" + filterValue;
            return link;
        } else {
            denyStateAccess = context + "/SecurityServlet?op=" + AppConstants.NOT_ISSUE_OWENER + "&issueState=" + ais.getStateName() + "&filterName=RiskReport&filterValue=" + filterValue;
            return  denyStateAccess;
        }
    }
     
      public String getNextStateRiskLink(String filterValue,String projectname) {
        
        if(isUserOwner || ais.getStateName().equalsIgnoreCase(IssueStatusFactory.SCHEDULE) || ais.getStateName().equalsIgnoreCase(IssueStatusFactory.REJECTED)){         
            String link =  ais.getNextStateLink() + "&filterName=RiskReport&filterValue=" + filterValue;
            return link;
        } else {
            denyStateAccess = context + "/SecurityServlet?op=" + AppConstants.NOT_ISSUE_OWENER + "&issueState=" + ais.getStateName() + "&filterName=RiskReport&filterValue=" + filterValue + "&projectName=" + projectname;
            return  denyStateAccess;
        }
    }
      
    public void setAssignedToID(String tid) {
        assignedToID = tid;
    }
    
    public String getAssignedToID() {
        return (assignedToID!=null?assignedToID:null);
    }
    
    public void setAssignedByID(String bid) {
        assignedByID = bid;
    }
    
    public String getAssignedByID() {
        return (assignedByID!=null?assignedByID:null);
    }
    
    public void setAssignedToName(String tName) {
        assignedToName = tName;
    }
    
    public String getAssignedToName() {
        return (assignedToName!=null?assignedToName:null);
    }
    
    public void setAssignedByName(String bName) {
        assignedByName = bName;
    }
    
    public String getAssignedByName() {
        return (assignedByName!=null?assignedByName:null);
    }
    
    public void setFinishedTime(String fTime) {
        finishedTime = new Integer(fTime);
    }
    
    public Integer getFinishedTime() {
        return finishedTime;
    }
    
    public void setManagerNote(String note) {
        managerNote = note;
    }
    
    public String getManagerNote() {
        return (managerNote!=null?managerNote:null);
    }
    
    public String getState() {
        return ais.getStateName();
    }
    
    public String getViewDetailLink() {
        // return ais.getViewDetailLink();
        if(viewOrigin != null){
        filterValue = (String) viewOrigin.getAttribute("filterValue");
        filterName = (String) viewOrigin.getAttribute("filter");
        }
        return context + "/AssignedIssueServlet?op=VIEWDETAILS&issueId=" + getAttribute("id") +  "&filterValue=" + filterValue + "&filterName=" + filterName;
    }
    
    public String getViewEditLink() {
        // return ais.getViewDetailLink();
        filterValue = (String) viewOrigin.getAttribute("filterValue");
        filterName = (String) viewOrigin.getAttribute("filter");
        
        return context + "/AssignedIssueServlet?op=editJobOrder&issueId=" + getAttribute("id") +  "&filterValue=" + filterValue + "&filterName=" + filterName;
    }
    
    public String getViewWorkerDetailLink() {
        // return ais.getViewDetailLink();
        //filterValue = (String) getAttribute("ownerId");
        filterValue = new String(ownerId);
        filterName = new String("ListResult");
        
        return context + "/AssignedIssueServlet?op=viewdetails&issueId=" + getAttribute("id") +  "&filterValue=" + filterValue + "&filterName=" + filterName;
    }
    
    public String getViewWorkerDetailLink(String projectname) {
        // return ais.getViewDetailLink();
        //filterValue = (String) getAttribute("ownerId");
        filterValue = new String(ownerId);
        filterName = new String("ListResult");
        
        return context + "/AssignedIssueServlet?op=viewdetails&issueId=" + getAttribute("id") +  "&filterValue=" + filterValue + "&filterName=" + filterName + "&projectName=" + projectname;
    }
    
    public String getViewHistoryLink() {
        filterValue = (String) viewOrigin.getAttribute("filterValue");
        filterName = (String) viewOrigin.getAttribute("filter");
        return context + "/SearchServlet?op=ViewHistory&issueId=" + getAttribute("id") +  "&fValue=" + filterValue + "&fName=" + filterName;
    }
    
    public String getAttachFileLink(String filterName,String filterValue,String projectname) {
        //filterValue = (String) viewOrigin.getAttribute("filterValue");
       // filterName = (String) viewOrigin.getAttribute("filter");
        return context + "/ImageWriterServlet?op=SelectFile&issueId=" + getAttribute("id") +  "&fValue=" + filterValue + "&fName=" + filterName +"&projectName=" + projectname;
    }
    public String getViewFileLink(String filterName,String filterValue,String projectname) {
//        filterValue = (String) viewOrigin.getAttribute("filterValue");
//        filterName = (String) viewOrigin.getAttribute("filter");
        filterBack="ListDoc";
        return context + "/ImageReaderServlet?op=ListDoc&issueId=" + getAttribute("id") +  "&fValue=" + filterValue + "&fName=" + filterName + "&filterBack=" + filterBack + "&projectName=" + projectname ;
    }
    public String getAttachFileLink() {
        filterValue = (String) viewOrigin.getAttribute("filterValue");
        filterName = (String) viewOrigin.getAttribute("filter");
        return context + "/ImageWriterServlet?op=SelectFile&issueId=" + getAttribute("id") +  "&fValue=" + filterValue + "&fName=" + filterName;
    }
    
    public String getAttachFileLink(String projectname) {
//        projectname = (String) getAttribute("projectname");
        filterValue = (String) viewOrigin.getAttribute("filterValue");
        filterName = (String) viewOrigin.getAttribute("filter");
        return context + "/ImageWriterServlet?op=SelectFile&issueId=" + getAttribute("id") +  "&fValue=" + filterValue + "&fName=" + filterName + "&projectName=" + projectname;
    }
    
    public String getViewFileLink() {
        filterValue = (String) viewOrigin.getAttribute("filterValue");
        filterName = (String) viewOrigin.getAttribute("filter");
        filterBack="ListDoc";
        return context + "/ImageReaderServlet?op=ListDoc&issueId=" + getAttribute("id") +  "&fValue=" + filterValue + "&fName=" + filterName + "&filterBack=" + filterBack ;
    }
    
    
    public String getViewWorkerHistoryLink() {
        filterValue = new String(ownerId);
        filterName = new String("ListResult");
        return context + "/SearchServlet?op=ViewHistory&issueId=" + getAttribute("id") +  "&fValue=" + filterValue + "&fName=" + filterName;
    }
    
    public String getViewWorkerHistoryLink(String projectname) {
        filterValue = new String(ownerId);
        filterName = new String("ListResult");
        return context + "/SearchServlet?op=ViewHistory&issueId=" + getAttribute("id") +  "&fValue=" + filterValue + "&fName=" + filterName + "&projectName=" + projectname;
    }
    
    public void setCentralViewLink(String link) {
        ais.setCentralViewLink(link);
        
    }
    
    public void setViewOrigin(WebBusinessObject viewOrigin) {
        this.viewOrigin = viewOrigin;
        filterName = (String) viewOrigin.getAttribute("filter");
        filterValue = (String) viewOrigin.getAttribute("filterValue");
        
        
        denyStateAccess = context + "/SecurityServlet?op=" + AppConstants.NOT_ISSUE_OWENER + "&issueState=" + ais.getStateName() + "&filterName=" + filterName + "&filterValue=" + filterValue;
        
    }
    
    public String getColor()
    {
        String sTemp = (String) getAttribute("isDelayed");
        if(sTemp.equalsIgnoreCase("true"))
        {
            return "red";
        }else
        {
            return "";
        }
    }
    
//    public void setViewOrigin(String origin) {
//
//        ais.setViewOrigin(origin);
//        denyStateAccess = "/Tracker/SecurityServlet?op=" + AppConstants.NOT_ISSUE_OWENER + "&issueState=" + ais.getStateName() + "&viewOrigin=" + ais.getViewOrigin();
//    }
    
    
    
}
