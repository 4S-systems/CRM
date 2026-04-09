package com.tracker.db_access;

import com.silkworm.business_objects.SqlMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.persistence.relational.IQueryMgr;
import com.silkworm.persistence.relational.*;
import java.util.*;

public class QMIssueInRange implements IQueryMgr {

    SqlMgr sqlMgr = SqlMgr.getInstance();
    /** Creates a new instance of AdminQueryGateway */
    WebBusinessObject sessionUser = null;

    public QMIssueInRange() {

    }

    public String getQuery(String forOperation, String param) {


        if (forOperation.equalsIgnoreCase("StatusProjectListALL")) {
            return sqlMgr.getSql("selectStatusProjectListALL").trim();
        }
        if (forOperation.equalsIgnoreCase("NoStatus")) {
            return sqlMgr.getSql("selectNoStatus").trim();
        }
        return null;
    }

    public Vector getQueryVectorParam(String concatParams) {
        Vector SQLParams = new Vector();

        int firstParamMark = concatParams.indexOf(">");
        int sepPos = concatParams.indexOf(":");
        String fromDate = concatParams.substring(0, sepPos);
        String toDate = concatParams.substring(sepPos + 1, firstParamMark);
        Long fromDateL = new Long(fromDate);
        Long toDateL = new Long(toDate);


        java.sql.Date d1 = new java.sql.Date(fromDateL.longValue());
        java.sql.Date d2 = new java.sql.Date(toDateL.longValue());

        Vector SQLparams = new Vector();
        SQLParams.addElement(new DateValue(d1));
        SQLParams.addElement(new DateValue(d2));

        return SQLParams;
    }
}
