// Decompiled by Jad v1.5.8f. Copyright 2001 Pavel Kouznetsov.
// Jad home page: http://www.kpdus.com/jad.html
// Decompiler options: packimports(3) 
// Source File Name:   ReassignedState.java

package com.tracker.engine;

import com.tracker.business_objects.WebIssue;

// Referenced classes of package com.tracker.engine:
//            AssignedIssueState

public class ReassignedState extends AssignedIssueState
{

    public ReassignedState(WebIssue webIssue)
    {
        super(webIssue);
    }

    public ReassignedState()
    {
    }

    public boolean isTerminal()
    {
        return false;
    }

    public String getNextStateLink()
    {
        return context + "/ProgressingIssueServlet?op=GetQAVerifyForm&issueId=" + ownerIssue.getAttribute("id") + "&issueTitle=" + ownerIssue.getAttribute("issueTitle") + "&viewOrigin=" + getViewOrigin() + "&" + "direction" + "=" + "forward" + "&state=" + getStateName();
    }

    public String getReverseStateAction()
    {
        return "Onhold";
    }

    public String getNextStateAction()
    {
        return "Close";
    }

    public String getNextStateName()
    {
        return "FINISHED";
    }

    public void updateState()
    {
    }

    public boolean canDelete()
    {
        return false;
    }

    public String getStateName()
    {
        return "REASSIGNED";
    }

    public String getCentralViewLink()
    {
        return "";
    }

    public String getReverseStateLink()
    {
        return context + "/ProgressingIssueServlet?op=GetWorkerNoteForm" + "&state=" + getStateName() + "&issueId=" + ownerIssue.getAttribute("id") + "&issueTitle=" + ownerIssue.getAttribute("issueTitle") + "&viewOrigin=" + getViewOrigin() + "&" + "direction" + "=" + "backward";
    }

    public String getReverseStateName()
    {
        return "Rejected";
    }

    public String getViewDetailLink()
    {
        return context + "/AssignedIssueServlet?op=viewdetails&issueId=" + ownerIssue.getAttribute("id") + "&issueState=" + getStateName() + "&viewOrigin=" + getViewOrigin();
    }
}
