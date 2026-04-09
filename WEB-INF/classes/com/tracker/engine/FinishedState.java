// Decompiled by Jad v1.5.8f. Copyright 2001 Pavel Kouznetsov.
// Jad home page: http://www.kpdus.com/jad.html
// Decompiler options: packimports(3) 
// Source File Name:   FinishedState.java

package com.tracker.engine;

import com.tracker.business_objects.WebIssue;

// Referenced classes of package com.tracker.engine:
//            AssignedIssueState

public class FinishedState extends AssignedIssueState
{

    public FinishedState()
    {
    }

    public FinishedState(WebIssue webIssue)
    {
        super(webIssue);
    }

    public boolean isTerminal()
    {
        return true;
    }

    public String getReverseStateAction()
    {
        return "Finished";
    }

    public String getNextStateAction()
    {
        return "Finished";
    }

    public String getNextStateLink()
    {
        return "";
    }

    public void updateState()
    {
    }

    public String getNextStateName()
    {
        return "";
    }

    public boolean canDelete()
    {
        return false;
    }

    public String getStateName()
    {
        return "FINISHED";
    }

    public String getReverseStateLink()
    {
        return "";
    }

    public String getReverseStateName()
    {
        return "";
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
