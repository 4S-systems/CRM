/*
 * IQueryMgr.java
 *
 * Created on March 31, 2005, 6:59 AM
 */

package com.silkworm.persistence.relational;

/**
 *
 * @author Walid
 */
import java.util.*;

public interface IQueryMgr {
    public String getQuery(String operation,String filter);
    public Vector getQueryVectorParam(String concatParams);
}
