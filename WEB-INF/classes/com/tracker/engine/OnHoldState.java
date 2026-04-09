// Decompiled by Jad v1.5.8f. Copyright 2001 Pavel Kouznetsov.
// Jad home page: http://www.kpdus.com/jad.html
// Decompiler options: packimports(3) 
// Source File Name:   OnHoldState.java

package com.tracker.engine;

import com.tracker.business_objects.WebIssue;

// Referenced classes of package com.tracker.engine:
//            AssignedIssueState

public class OnHoldState extends AssignedIssueState
{

    public OnHoldState()
    {
    }

    public OnHoldState(WebIssue webIssue)
    {
        super(webIssue);
    }

    public boolean isTerminal()
    {
        return false;
    }

    public String getReverseStateAction()
    {
        return "Cancel";
    }

    public String getNextStateAction()
    {
        return "Continue";
    }

    public boolean canDelete()
    {
        return false;
    }

    public String getNextStateLink()
    {
        return context + "/ProgressingIssueServlet?op=GetWorkerNoteForm" + "&state=" + getStateName() + "&viewOrigin=" + getViewOrigin() + "&issueId=" + ownerIssue.getAttribute("id") + "&issueTitle=" + ownerIssue.getAttribute("issueTitle") + "&" + "direction" + "=" + "forward";
    }

    public String getNextStateName()
    {
        return "Assigned";
    }

    public String getStateName()
    {
        return "ONHOLD";
    }

    public void updateState()
    {
    }

    public String getReverseStateLink()
    {
        return context + "/ProgressingIssueServlet?op=GetWorkerNoteForm" + "&state=" + getStateName() + "&issueId=" + ownerIssue.getAttribute("id") + "&issueTitle=" + ownerIssue.getAttribute("issueTitle") + "&viewOrigin=" + getViewOrigin() + "&" + "direction" + "=" + "backward";
    }

    public String getReverseStateName()
    {
        return "Canceled";
    }

    public String getCentralViewLink()
    {
        if(centralViewLink == null)
            return context + "/AssignedIssueServlet?op=ListAssigned";
        else
            return centralViewLink;
    }

    public String getViewDetailLink()
    {
        return context + "/AssignedIssueServlet?op=viewdetails&issueId=" + ownerIssue.getAttribute("id") + "&issueState=" + getStateName() + "&viewOrigin=" + getViewOrigin();
    }
}
