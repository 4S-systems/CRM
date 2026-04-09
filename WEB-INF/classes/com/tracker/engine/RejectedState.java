// Decompiled by Jad v1.5.8f. Copyright 2001 Pavel Kouznetsov.
// Jad home page: http://www.kpdus.com/jad.html
// Decompiler options: packimports(3) 
// Source File Name:   RejectedState.java

package com.tracker.engine;

import com.tracker.business_objects.WebIssue;

// Referenced classes of package com.tracker.engine:
//            AssignedIssueState

public class RejectedState extends AssignedIssueState
{

    public RejectedState()
    {
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
        return "ReAssign";
    }

    public RejectedState(WebIssue webIssue)
    {
        super(webIssue);
    }

    public boolean canDelete()
    {
        return false;
    }

    public String getCentralViewLink()
    {
        if(centralViewLink == null)
            return context + "/IssueServlet?op=ListSchedule";
        else
            return centralViewLink;
    }

    public String getNextStateLink()
    {
        return context + "/AssignedIssueServlet?op=assign" + "&state=" + getStateName() + "&viewOrigin=" + getViewOrigin() + "&issueId=" + ownerIssue.getAttribute("id") + "&" + "direction" + "=" + "forward" + "&issueTitle=" + ownerIssue.getAttribute("issueTitle");
    }

    public String getNextStateName()
    {
        return "ReAssigned";
    }

    public String getReverseStateLink()
    {
        return context + "/ProgressingIssueServlet?op=GetWorkerNoteForm&issueId=" + ownerIssue.getAttribute("id") + "&issueTitle=" + ownerIssue.getAttribute("issueTitle") + "&viewOrigin=" + getViewOrigin() + "&" + "direction" + "=" + "backward" + "&state=" + getStateName();
    }

    public String getReverseStateName()
    {
        return "Canceled";
    }

    public String getStateName()
    {
        return "REJECTED";
    }

    public String getViewDetailLink()
    {
        return "";
    }

    public void updateState()
    {
    }
}
