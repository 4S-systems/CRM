/*
 * QueryMgrFactory.java
 *
 * Created on 2005-06-26, 9.29.PD
 *
 * To change this template, choose Tools | Options and locate the template under
 * the Source Creation and Management node. Right-click the template and choose
 * Open. You can then make changes to the template in the Source Editor.
 */
package com.tracker.db_access;

/**
 *
 * @author Administrator
 */
import com.silkworm.persistence.relational.IQueryMgr;
import com.silkworm.business_objects.WebBusinessObject;

public class QueryMgrFactory {

    /** Creates a new instance of QueryMgrFactory */
    private static QueryMgrFactory qMgrFactory = new QueryMgrFactory();
    WebBusinessObject sessionUser = null;
    private static IQueryMgr qm0 = new QMIssueInRange();
    private static IQueryMgr qm1 = new QMProjectStatus();
    private static IQueryMgr qm2 = new QMIssueStatus();

    private QueryMgrFactory() {

    }

    public static QueryMgrFactory getInstance() {

        return qMgrFactory;
    }

    public IQueryMgr getQueryMgr(String queryParams) {

        int firstParamMark = queryParams.indexOf(">");
        int secondParamMark = queryParams.indexOf("<");
        String firstParam = queryParams.substring(firstParamMark + 1, secondParamMark);
        String secondParam = queryParams.substring(secondParamMark + 1);

        if (firstParam.equalsIgnoreCase(secondParam)) {
            return qm0;
        }

        if (!firstParam.equalsIgnoreCase("ALL") && !secondParam.equalsIgnoreCase("ALL")) {
            return qm2;
        }

        if (firstParam.equalsIgnoreCase("ALL") && !secondParam.equalsIgnoreCase("ALL")) {
            return qm2;
        }
        if (!firstParam.equalsIgnoreCase("ALL") && secondParam.equalsIgnoreCase("ALL")) {
            return qm1;
        }


        // return new QueryMgr1(sessionUser);
        return qm0;
    }
}
