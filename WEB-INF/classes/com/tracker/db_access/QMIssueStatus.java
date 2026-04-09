/*
 * QueryMgr1.java
 *
 * Created on 2005-06-26, 8.57.PD
 *
 * To change this template, choose Tools | Options and locate the template under
 * the Source Creation and Management node. Right-click the template and choose
 * Open. You can then make changes to the template in the Source Editor.
 */
package com.tracker.db_access;

import com.silkworm.business_objects.SqlMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.persistence.relational.IQueryMgr;

import com.silkworm.persistence.relational.*;

import java.util.*;

/**
 *
 * @author Administrator
 */
public class QMIssueStatus implements IQueryMgr {

    SqlMgr sqlMgr = SqlMgr.getInstance();
    /** Creates a new instance of QueryMgr1 */
    WebBusinessObject sessionUser = null;

    public QMIssueStatus() {

    }

    public String getQuery(String forOperation, String param) {
        if (forOperation.equalsIgnoreCase("StatusProjectListALL")) {
            return sqlMgr.getSql("selectIssueStatusProjectListALL").trim();
        } else if (forOperation.equalsIgnoreCase("NoStatus")) {
            return sqlMgr.getSql("selectIssueStatusProjectListALL").trim();
        } else {
            return sqlMgr.getSql("selectIssueNoStatus").trim();
        }
    }

    public Vector getQueryVectorParam(String concatParams) {

        int firstParamMark = concatParams.indexOf(">");
        int secondParamMark = concatParams.indexOf("<");

        String firstParam = concatParams.substring(firstParamMark + 1, secondParamMark);
        String secondParam = concatParams.substring(secondParamMark + 1);


        Vector SQLParams = new Vector();
        int sepPos = concatParams.indexOf(":");


        String fromDate = concatParams.substring(0, sepPos);
        String toDate = concatParams.substring(sepPos + 1, firstParamMark);
        Long fromDateL = new Long(fromDate);
        Long toDateL = new Long(toDate);


        java.sql.Date d1 = new java.sql.Date(fromDateL.longValue());
        java.sql.Date d2 = new java.sql.Date(toDateL.longValue());

        Vector SQLparams = new Vector();
        SQLParams.addElement(new StringValue(firstParam));
        SQLParams.addElement(new StringValue(secondParam));
        SQLParams.addElement(new DateValue(d1));
        SQLParams.addElement(new DateValue(d2));


        return SQLParams;
    }
}
