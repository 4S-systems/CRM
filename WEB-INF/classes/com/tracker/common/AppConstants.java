/*
 * AppConstants.java
 *
 * Created on February 17, 2004, 5:48 AM
 */

package com.tracker.common;

/**
 *
 * @author  walid
 */
/*
 * HazmanAppConstants.java
 *
 * Created on November 3, 2003, 9:39 PM
 */



/**
 *
 * @author  walid
 */
import com.tracker.business_objects.*;
import com.silkworm.common.*;
import java.util.*;
import com.tracker.engine.IssueStatusFactory;

public class AppConstants {
    
    public static final String LC_ASSIGNED  = "Assigned";
    public static final String LC_SCHEDULE  = "Schedule";
    public static final String LC_IN_PRGRESS  = "Inprogress";
    public static final String LC_RESOLVED  = "Resolved";
    public static final String LC_RE_ASSIGNED  = "Reassigned";
    public static final String LC_CLOSED  = "Closed";
    public static final String LC_DELETED  = "Canceled";
    public static final String LC_REJECTED  = "Rejected";
    public static final String ISSUETITLE = "issueTitle";
    
    
    
    /** Creates a new instance of HazmanAppConstants */
    public static final String LIST_ALL = "ListAll"; // list all issues
    public static final String LIST_SCHEDULE = "ListSchedule";
    public static final String LIST_USER_ASSIGNED = "ListAssigned";
    
    public static final String FORWARD_DIRECTION = "forward";
    public static final String BACKWARD_DIRECTION = "backward";
    public static final String DIRECTION = "direction";
    
    public static final String NOT_ISSUE_OWENER = "NotIssueOwner";
    protected static String  context = null;
    private Properties mappedTitle = new Properties();
    private String[] userPref = null;
    
    private String[] issueAttributes = {"issueDesc","expectedBeginDate","currentStatus"};
    private String[] issueHeaders = {"&#1575;&#1604;&#1578;&#1601;&#1575;&#1589;&#1610;&#1604;","&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1576;&#1583;&#1575;&#1610;&#1577; &#1575;&#1604;&#1605;&#1578;&#1608;&#1602;&#1593;","&#1575;&#1604;&#1581;&#1575;&#1604;&#1607;","&#1573;&#1587;&#1605; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;","&#1593;&#1606;&#1608;&#1575;&#1606; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607;","&#1575;&#1604;&#1578;&#1575;&#1585;&#1610;&#1582;","&#1573;&#1585;&#1601;&#1602; &#1605;&#1587;&#1578;&#1606;&#1583;","&#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;&#1575;&#1578;","&#1593;&#1604;&#1575;&#1605;&#1607;","&#1604;&#1604;&#1582;&#1604;&#1601;","&#1604;&#1604;&#1571;&#1605;&#1575;&#1605;"};
    
    private String[] issueStatusAtt = {"statusName","beginDate", "endDate","statusNote"};
    private String[] issueStatusHeaders = {"Status Name", "Begain Date", "End Date","Notes"};
    
    private String[] issueDivAttributes = {"id","projectName", "issueTitle","faId","issueType","urgencyId","currentStatus","beginDeviation","endDeviation","estimatedDeviation"};
    private String[] issueDivHeaders = {"Schedule Id.", "Site", "Title","Maintenance","Type","Urgency","Status","Begin Date","End Date","Estimated Finish Time"};
    
    private String[] projectStatusAtt = {"issueTitle","expectedBeginDate", "expectedEndDate","currentStatus","assignedToName","assignedByName"};
    private String[] projectStatusHeaders = {"&#1593;&#1606;&#1608;&#1575;&#1606; &#1575;&#1604;&#1580;&#1583;&#1608;&#1604;", "&#1608;&#1602;&#1578; &#1575;&#1604;&#1576;&#1583;&#1575;&#1610;&#1577; &#1575;&#1604;&#1605;&#1578;&#1608;&#1602;&#1593;", "&#1608;&#1602;&#1578; &#1575;&#1604;&#1606;&#1607;&#1575;&#1610;&#1577; &#1575;&#1604;&#1605;&#1578;&#1608;&#1602;&#1593;","&#1575;&#1604;&#1581;&#1575;&#1604;&#1607;","&#1605;&#1587;&#1604;&#1605; &#1573;&#1604;&#1609;","&#1605;&#1587;&#1604;&#1605; &#1576;&#1608;&#1575;&#1587;&#1591;&#1577;","&#1578;&#1581;&#1585;&#1610;&#1585;","&#1581;&#1584;&#1601;"};
    
    private String[] issueMaintenanceAtt = {"issueTitle", "expectedBeginDate", "expectedEndDate", "assignedToName"};
    private String[] issueMaintenanceHeaders = {"Schedule Title", "Begain Date", "End Date", "Assigned To"};
    
    private String[] projectWorkerAtt = {"issueTitle","faId","actualFinishTime"};
    private String[] projectWorkerHeaders = {"Schedule Title", "Maintenance", "Hours"};
    
    private String[] projectHoursAtt = {"projectName","assignedToName"};
    private String[] projectHoursHeaders = {"Site Name", "Assigned To","Edit","Delete"};
    
    private String[] ItemScheduleAtt = {"itemId","itemQuantity","itemPrice","totalCost", "note"};
    private String[] ItemScheduleHeaders = {"Part Name", "Quantity","Part Price","Total Cost", "Note"};

    private String[] ItemScheduleAttByEff = {"itemId","itemQuantity","itemPrice","totalCost","efficient", "note"};
    private String[] ItemScheduleHeadersByEff = {"Part Name", "Quantity","Part Price","Total Cost","EFFICIENT", "Note"};

    
    
    public AppConstants(){
        mappedTitle.setProperty("id", "Schedule Id");
        mappedTitle.setProperty("issueTitle", "Schedule Title");
        mappedTitle.setProperty("faId", "Site:");
        mappedTitle.setProperty("issueId", "Issue Type");
        
        mappedTitle.setProperty("urgencyId", "Issue Urgency");
        mappedTitle.setProperty("currentStatus", "Curr. Status");
        
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        // tGuide = new TouristGuide("/com/docviewer/international/DocOnlineMenu");
        
        context= metaMgr.getContext();
        
    }
    public String[] getIssueAttributes() {
        
        return  issueAttributes;
    }
    
    public String[] getIssueHeaders() {
        
        return  issueHeaders;
    }
    
    public String[] getItemScheduleAttributes() {
        
        return  ItemScheduleAtt;
    }
    
    public String[] getItemScheduleHeaders() {
        
        return  ItemScheduleHeaders;
    }
    
    public String[] getIssueMaintenanceAttributes() {
        
        return  issueMaintenanceAtt;
    }
    
    public String[] getIssueMaintenanceHeaders() {
        
        return  issueMaintenanceHeaders;
    }
    
    public String[] getIssueStatusAtt() {
        
        return  issueStatusAtt;
    }
    
    
    
    public String[] getIssueStatusHeaders() {
        
        return  issueStatusHeaders;
    }
    
    public String[] getIssueDivAttributes() {
        
        return  issueDivAttributes;
    }
    
    public String[] getIssueDivHeaders() {
        
        return  issueDivHeaders;
    }
    
    public String[] getProjectStatusAtt() {
        
        return  projectStatusAtt;
    }
    
    public String[] getProjectStatusHeaders() {
        
        return  projectStatusHeaders;
    }
    
    public String[] getprojectWorkerAtt() {
        
        return  projectWorkerAtt;
    }
    
    public String[] getprojectWorkerHeaders() {
        
        return  projectWorkerHeaders;
    }
    
     public String[] getprojectHoursAtt() {
        
        return  projectHoursAtt;
    }
    
    public String[] getprojectHoursHeaders() {
        
        return  projectHoursHeaders;
    }
    
    public String getHeader(String attributeName) {
        return mappedTitle.getProperty(attributeName);
    }
    
    public void setUserPref(String[] asPerRequest) {
        userPref =  asPerRequest;
    }
    
    
    private String binaryContains(String entry) {
        int l = userPref.length;
        for (int i = 0; i < l; i++) {
            if (entry.equals(userPref[i])) {
                return "1";
                
            }
        }
        return "0";
    }
    public static String getFullLink(String opCode, String filterValue) {
        
        System.out.println("The opCode is : ***** " + opCode);
        if(opCode.equalsIgnoreCase(LIST_ALL))
            return "/SearchServlet?op=" + LIST_ALL;
        
        if(opCode.equalsIgnoreCase(LIST_SCHEDULE))
            return context + "/IssueServlet?op=" + LIST_SCHEDULE;
        
        
        if(opCode.equalsIgnoreCase(LIST_USER_ASSIGNED))
            return context + "/AssignedIssueServlet?op=" + LIST_USER_ASSIGNED;
        
        if(opCode.equalsIgnoreCase("StatusProjectListAll"))
            return "/SearchServlet?op=StatusProjectListAll&filterValue="+filterValue;
        
        if(opCode.equalsIgnoreCase("ListResult"))
            return "/SearchServlet?op=ListResult&filterValue="+filterValue;
        
        if(opCode.equalsIgnoreCase("SearchTitle"))
            return "/SearchServlet?op=SearchTitle&filterValue="+filterValue;
        
        if(opCode.equalsIgnoreCase("SearchNote"))
            return "/SearchServlet?op=SearchNote&filterValue="+filterValue;
        
        if(opCode.equalsIgnoreCase("StatusReport"))
            return "/SearchServlet?op=StatusReport&filterValue="+filterValue;

        if(opCode.equalsIgnoreCase("RiskReport"))
            return "/SearchServlet?op=RiskReport&filterValue="+filterValue;


        if(opCode.equalsIgnoreCase("StatusProjectList"))
            return "/SearchServlet?op=StatusProjectListAll&filterValue="+filterValue;

        if(opCode.equalsIgnoreCase("getJobOrdersByLateClosed"))
            return "/SearchServlet?op=getJobOrdersByLateClosed&filterValue="+filterValue;
        return null;
    }
    
    public static String getFullLink(String opCode, String filterValue,String projectname) {
        
        System.out.println("The opCode is : ***** " + opCode);
        if(opCode.equalsIgnoreCase(LIST_ALL))
            return "/SearchServlet?op=" + LIST_ALL;
        
        if(opCode.equalsIgnoreCase(LIST_SCHEDULE))
            return context + "/IssueServlet?op=" + LIST_SCHEDULE;
        
        
        if(opCode.equalsIgnoreCase(LIST_USER_ASSIGNED))
            return context + "/AssignedIssueServlet?op=" + LIST_USER_ASSIGNED;
        
        if(opCode.equalsIgnoreCase("StatusProjectListAll"))
            return "/SearchServlet?op=StatusProjectListAll&filterValue="+filterValue;
        
        if(opCode.equalsIgnoreCase("ListResult"))
            return "/SearchServlet?op=ListResult&filterValue="+filterValue+"&projectName=" + projectname;
        
        if(opCode.equalsIgnoreCase("SearchTitle"))
            return "/SearchServlet?op=SearchTitle&filterValue="+filterValue;
        
        if(opCode.equalsIgnoreCase("SearchNote"))
            return "/SearchServlet?op=SearchNote&filterValue="+filterValue;
        
        if(opCode.equalsIgnoreCase("StatusReport"))
            return "/SearchServlet?op=StatusReport&filterValue="+filterValue;
        if(opCode.equalsIgnoreCase("RiskReport"))
            return "/SearchServlet?op=RiskReport&filterValue="+filterValue;
        
        return null;
    }
    public static String getFullLink(String opCode) {
        
        System.out.println("The opCode is : ***** " + opCode);
        if(opCode.equalsIgnoreCase(LIST_ALL))
            return "/SearchServlet?op=" + LIST_ALL;
        
        if(opCode.equalsIgnoreCase(LIST_SCHEDULE))
            return context + "/IssueServlet?op=" + LIST_SCHEDULE;
        
        
        if(opCode.equalsIgnoreCase(LIST_USER_ASSIGNED))
            return context + "/AssignedIssueServlet?op=" + LIST_USER_ASSIGNED;
                
        
        return null;
    }
    
    public static String getMatchingView(String status) {
        if(status.equalsIgnoreCase(IssueStatusFactory.ASSIGNED)) {
            return AppConstants.LIST_USER_ASSIGNED;
        }
        return "";
    }

    public String[] getItemScheduleAttByEff() {
        return ItemScheduleAttByEff;
    }

    
    public String[] getItemScheduleHeadersByEff() {
        return ItemScheduleHeadersByEff;
    }

    
   
    public String[] getItemScheduleAttributesByEff() {

        return  getItemScheduleAttByEff();
    }

}
