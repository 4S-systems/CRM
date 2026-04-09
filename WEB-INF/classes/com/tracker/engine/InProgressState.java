// Decompiled by Jad v1.5.8f. Copyright 2001 Pavel Kouznetsov.
// Jad home page: http://www.kpdus.com/jad.html
// Decompiler options: packimports(3) 
// Source File Name:   InProgressState.java

package com.tracker.engine;

import com.tracker.business_objects.WebIssue;

// Referenced classes of package com.tracker.engine:
//            AssignedIssueState

public class InProgressState extends AssignedIssueState
{

    public InProgressState()
    {
    }

    public boolean isTerminal()
    {
        return false;
    }

    public InProgressState(WebIssue wIssue)
    {
        super(wIssue);
        ownerIssue = wIssue;
    }

    public String getReverseStateAction()
    {
        return "Put On Hold";
    }

    public String getNextStateAction()
    {
        return "Resolve";
    }

    public String getNextStateName()
    {
        return "Resolved";
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
        return "INPROGRESS";
    }

    public String getNextStateLink()
    {
        return context + "/ProgressingIssueServlet?op=GetProgrammerNoteForm&issueId=" + ownerIssue.getAttribute("id") + "&issueTitle=" + ownerIssue.getAttribute("issueTitle") + "&viewOrigin=" + getViewOrigin() + "&" + "direction" + "=" + "forward" + "&state=" + getStateName();
    }

    public String getCentralViewLink()
    {
        return context + "/IssueServlet?op=ListSchedule";
    }

    public String getReverseStateLink()
    {
        return context + "/ProgressingIssueServlet?op=GetWorkerNoteForm" + "&state=" + getStateName() + "&issueId=" + ownerIssue.getAttribute("id") + "&issueTitle=" + ownerIssue.getAttribute("issueTitle") + "&viewOrigin=" + getViewOrigin() + "&" + "direction" + "=" + "backward";
    }

    public String getReverseStateName()
    {
        return "OnHold";
    }

    public String getViewDetailLink()
    {
        return "";
    }
}
