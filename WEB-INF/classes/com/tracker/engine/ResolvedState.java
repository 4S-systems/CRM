// Decompiled by Jad v1.5.8f. Copyright 2001 Pavel Kouznetsov.
// Jad home page: http://www.kpdus.com/jad.html
// Decompiler options: packimports(3) 
// Source File Name:   ResolvedState.java

package com.tracker.engine;

import com.tracker.business_objects.WebIssue;

// Referenced classes of package com.tracker.engine:
//            AssignedIssueState

public class ResolvedState extends AssignedIssueState
{

    public ResolvedState()
    {
    }

    public ResolvedState(WebIssue webIssue)
    {
        super(webIssue);
    }

    public boolean isTerminal()
    {
        return false;
    }

    public String getReverseStateAction()
    {
        return "Reassign";
    }

    public String getNextStateAction()
    {
        return "Close";
    }

    public String getNextStateLink()
    {
        return context + "/ProgressingIssueServlet?op=GetQAVerifyForm&issueId=" + ownerIssue.getAttribute("id") + "&issueTitle=" + ownerIssue.getAttribute("issueTitle") + "&viewOrigin=" + getViewOrigin() + "&" + "direction" + "=" + "forward" + "&state=" + getStateName();
    }

    public String getNextStateName()
    {
        return "Finished";
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
        return "RESOLVED";
    }

    public String getReverseStateLink()
    {
        return context + "/AssignedIssueServlet?op=reassign&state=" + getStateName() + "&issueId=" + ownerIssue.getAttribute("id") + "&issueTitle=" + ownerIssue.getAttribute("issueTitle") + "&viewOrigin=" + getViewOrigin() + "&" + "direction" + "=" + "backward";
    }

    public String getReverseStateName()
    {
        return "Reassign";
    }

    public String getCentralViewLink()
    {
        return "";
    }

    public String getViewDetailLink()
    {
        return "";
    }
}
