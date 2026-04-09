// Decompiled by Jad v1.5.8f. Copyright 2001 Pavel Kouznetsov.
// Jad home page: http://www.kpdus.com/jad.html
// Decompiler options: packimports(3)
// Source File Name:   UnassignedState.java

package com.tracker.engine;

import com.tracker.business_objects.WebIssue;

// Referenced classes of package com.tracker.engine:
//            AssignedIssueState

public class UnassignedState extends AssignedIssueState {
    
    public UnassignedState(WebIssue webIssue) {
        super(webIssue);
    }
    
    public UnassignedState() {
    }
    
    public boolean isTerminal() {
        return false;
    }
    
    public String getReverseStateAction() {
        return "Cancel";
    }
    
    public String getNextStateAction() {
        return "Assign";
    }
    
    public String getNextStateLink() {
        return context + "/AssignedIssueServlet?op=assign" + "&state=" + getStateName() + "&viewOrigin=" + getViewOrigin() + "&issueId=" + ownerIssue.getAttribute("id") + "&" + "direction" + "=" + "forward" + "&issueTitle=" + ownerIssue.getAttribute("issueTitle");
    }
    
    public String getNextStateName() {
        return "Assigned";
    }
    
    public void updateState() {
    }
    
    public boolean canDelete() {
        return false;
    }
    
    public String getStateName() {
        return "SCHEDULE";
    }
    
    public String getReverseStateLink() {
        return context + "/ProgressingIssueServlet?op=GetWorkerNoteForm&issueId=" + ownerIssue.getAttribute("id") + "&issueTitle=" + ownerIssue.getAttribute("issueTitle") + "&viewOrigin=" + getViewOrigin() + "&" + "direction" + "=" + "backward" + "&state=" + getStateName();
    }
    
    public String getReverseStateName() {
        return "Canceled";
    }
    
    public String getCentralViewLink() {
        if(centralViewLink == null)
            return context + "/IssueServlet?op=ListSchedule";
        else
            return centralViewLink;
    }
    
    public String getViewDetailLink() {
        return context + "/IssueServlet?op=viewdetails&issueId=" + ownerIssue.getAttribute("id") + "&issueState=" + getStateName() + "&viewOrigin=" + getViewOrigin();
    }
}
