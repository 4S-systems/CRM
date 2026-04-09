// Decompiled by Jad v1.5.8f. Copyright 2001 Pavel Kouznetsov.
// Jad home page: http://www.kpdus.com/jad.html
// Decompiler options: packimports(3) 
// Source File Name:   ClosedState.java

package com.tracker.engine;

import com.tracker.business_objects.WebIssue;

// Referenced classes of package com.tracker.engine:
//            AssignedIssueState

public class ClosedState extends AssignedIssueState
{

    public ClosedState()
    {
    }

    public ClosedState(WebIssue webIssue)
    {
        super(webIssue);
    }

    public boolean isTerminal()
    {
        return true;
    }

    public String getReverseStateAction()
    {
        return "";
    }

    public String getNextStateAction()
    {
        return "";
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
        return "CLOSED";
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
