// Decompiled by Jad v1.5.8f. Copyright 2001 Pavel Kouznetsov.
// Jad home page: http://www.kpdus.com/jad.html
// Decompiler options: packimports(3)
// Source File Name:   IssueStatusFactory.java

package com.tracker.engine;

import com.tracker.business_objects.WebIssue;

// Referenced classes of package com.tracker.engine:
//            UnassignedState, AssignedState, RejectedState, InProgressState,
//            DeletedState, ResolvedState, OnHoldState, ClosedState,
//            ReassignedState, FinishedState, AssignedIssueState

public class IssueStatusFactory {
    
    public IssueStatusFactory() {
    }
    
    public static AssignedIssueState getStateClass(String state, WebIssue webIssue) {
        if(state!=null){
            if(state.equalsIgnoreCase("SCHEDULE"))
                return new UnassignedState(webIssue);
            if(state.equalsIgnoreCase("ASSIGNED"))
                return new AssignedState(webIssue);
            if(state.equalsIgnoreCase("REJECTED"))
                return new RejectedState(webIssue);
            if(state.equalsIgnoreCase("INPROGRESS"))
                return new InProgressState(webIssue);
            if(state.equalsIgnoreCase("Canceled"))
                return new DeletedState(webIssue);
            if(state.equalsIgnoreCase("RESOLVED"))
                return new ResolvedState(webIssue);
            if(state.equalsIgnoreCase("ONHOLD"))
                return new OnHoldState(webIssue);
            if(state.equalsIgnoreCase("CLOSED"))
                return new ClosedState(webIssue);
            if(state.equalsIgnoreCase("REASSIGNED"))
                return new ReassignedState(webIssue);
            if(state.equalsIgnoreCase("FINISHED"))
                return new FinishedState(webIssue);
            else
                return new FinishedState(webIssue);
        }else
            return new FinishedState(webIssue);
    }
    
    public static AssignedIssueState getStateClass(String state) {
        if(state.equalsIgnoreCase("SCHEDULE"))
            return new UnassignedState();
        if(state.equalsIgnoreCase("ASSIGNED"))
            return new AssignedState();
        if(state.equalsIgnoreCase("REJECTED"))
            return new RejectedState();
        if(state.equalsIgnoreCase("INPROGRESS"))
            return new InProgressState();
        if(state.equalsIgnoreCase("Canceled"))
            return new DeletedState();
        if(state.equalsIgnoreCase("RESOLVED"))
            return new ResolvedState();
        if(state.equalsIgnoreCase("ONHOLD"))
            return new OnHoldState();
        if(state.equalsIgnoreCase("CLOSED"))
            return new ClosedState();
        if(state.equalsIgnoreCase("REASSIGNED"))
            return new ReassignedState();
        else
            return null;
    }
    
    public static final String ASSIGNED = "ASSIGNED";
    public static final String SCHEDULE = "SCHEDULE";
    public static final String IN_PRGRESS = "INPROGRESS";
    public static final String RESOLVED = "RESOLVED";
    public static final String RE_ASSIGNED = "REASSIGNED";
    public static final String CLOSED = "CLOSED";
    public static final String DELETED = "Canceled";
    public static final String REJECTED = "REJECTED";
    public static final String ONHOLD = "ONHOLD";
    public static final String REASSIGNED = "REASSIGNED";
    public static final String FINISHED = "FINISHED";
}
