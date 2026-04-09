// Decompiled by Jad v1.5.8f. Copyright 2001 Pavel Kouznetsov.
// Jad home page: http://www.kpdus.com/jad.html
// Decompiler options: packimports(3) 
// Source File Name:   DeletedState.java

package com.tracker.engine;

import com.tracker.business_objects.WebIssue;

// Referenced classes of package com.tracker.engine:
//            AssignedIssueState

public class DeletedState extends AssignedIssueState
{

    public DeletedState(WebIssue webIssue)
    {
        super(webIssue);
    }

    public DeletedState()
    {
    }

    public boolean isTerminal()
    {
        return false;
    }

    public String getReverseStateAction()
    {
        return "Remove";
    }

    public String getNextStateAction()
    {
        return "NONE";
    }

    public String getNextStateLink()
    {
        return "";
    }

    public String getNextStateName()
    {
        return "";
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
        return "Canceled";
    }

    public String getCentralViewLink()
    {
        return "";
    }

    public String getReverseStateLink()
    {
        return context + "/ProgressingIssueServlet?op=BusinessRoll" + "&issueId=" + ownerIssue.getAttribute("id") + "&issueTitle=" + ownerIssue.getAttribute("issueTitle") + "&viewOrigin=" + getViewOrigin() + "&" + "direction" + "=" + "backward";
    }

    public String getReverseStateName()
    {
        return "Removed";
    }

    public String getViewDetailLink()
    {
        return "";
    }
}
