// Decompiled by Jad v1.5.8f. Copyright 2001 Pavel Kouznetsov.
// Jad home page: http://www.kpdus.com/jad.html
// Decompiler options: packimports(3) 
// Source File Name:   AssignedIssueState.java

package com.tracker.engine;

import com.silkworm.common.MetaDataMgr;
import com.tracker.business_objects.WebIssue;
import java.io.PrintStream;

public abstract class AssignedIssueState
{

    public AssignedIssueState(WebIssue wIssue)
    {
        centralViewLink = null;
        viewOrgin = null;
        ownerIssue = null;
        context = null;
        metaMgr = MetaDataMgr.getInstance();
        context = metaMgr.getContext();
        System.out.println("context----------------- " + context);
        ownerIssue = wIssue;
    }

    public AssignedIssueState()
    {
        centralViewLink = null;
        viewOrgin = null;
        ownerIssue = null;
        context = null;
        metaMgr = MetaDataMgr.getInstance();
    }

    public void setCentralViewLink(String link)
    {
        centralViewLink = link;
    }

    public void setViewOrigin(String origin)
    {
        viewOrgin = origin;
    }

    public String getViewOrigin()
    {
        return viewOrgin;
    }

    public abstract String getNextStateName();

    public abstract String getNextStateAction();

    public abstract String getReverseStateAction();

    public abstract String getNextStateLink();

    public abstract void updateState();

    public abstract boolean canDelete();

    public abstract String getStateName();

    public abstract String getReverseStateName();

    public abstract String getReverseStateLink();

    public abstract String getCentralViewLink();

    public abstract String getViewDetailLink();

    public abstract boolean isTerminal();

    public void printSelf()
    {
        System.out.println("State Name is : " + getStateName());
    }

    protected String centralViewLink;
    protected String viewOrgin;
    protected WebIssue ownerIssue;
    protected String context;
    private MetaDataMgr metaMgr;
}
