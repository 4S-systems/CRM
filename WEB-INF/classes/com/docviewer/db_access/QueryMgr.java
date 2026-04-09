package com.docviewer.db_access;

import com.silkworm.business_objects.SqlMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.persistence.relational.IQueryMgr;
import java.util.*;
public class QueryMgr implements IQueryMgr{
    SqlMgr sqlMgr = SqlMgr.getInstance();
    
    WebBusinessObject sessionUser = null;
    
    public QueryMgr(WebBusinessObject user) {
        sessionUser = user;
    }
    
    public String getQuery(String forOperation) {
        
        if(forOperation.equalsIgnoreCase("ListAll")) {
//            StringBuffer query = new StringBuffer("SELECT DOC_ID,PARENT_ID,DOC_TITLE,ACCOUNT,ACCNT_ITEM_NAME,DOC_DATE,DOC_META_TYPE,TOTAL,DOC_TYPE,STRUCTURE_TYPE,CREATED_BY,GROUP_NAME,IS_BASELINE,IS_LAST_BASELINE,IS_HIDDEN,DISPLAY_STATUS,SW_DOC_TYPE,CONFIG_ITEM_TYPE,VERSION_NUMBER,MODIFIED_BY,REVIEWED_BY,APPROVED_BY,RELEASE_DATE,IS_LOCKED FROM document WHERE IS_HIDDEN = \"FALSE\"");
//            query.append(" ORDER BY CREATION_TIME");
            return sqlMgr.getSql("selectListAllQuery").trim();
        }
        
        if(forOperation.equalsIgnoreCase("ListAllContext")) {
//            StringBuffer query = new StringBuffer("SELECT DOC_ID,PARENT_ID,DOC_TITLE,ACCOUNT,ACCNT_ITEM_NAME,DOC_DATE,DOC_META_TYPE,TOTAL,DOC_TYPE,STRUCTURE_TYPE,CREATED_BY,GROUP_NAME,IS_BASELINE,IS_LAST_BASELINE,IS_HIDDEN,DISPLAY_STATUS,SW_DOC_TYPE,CONFIG_ITEM_TYPE,VERSION_NUMBER,MODIFIED_BY,REVIEWED_BY,APPROVED_BY,RELEASE_DATE,IS_LOCKED FROM document");
//            query.append(" WHERE CREATED_BY =").append(sessionUser.getAttribute("userId"));
//            query.append(" AND IS_HIDDEN = \"FALSE\" ORDER BY CREATION_TIME");
            return sqlMgr.getSql("selectListAllContextQuery").trim().replace("$", sessionUser.getAttribute("userId").toString());
            
        }
        
        return null;
    }
    
    public String getQuery(String forOperation,String param) {
        
        // like search for MGR=Manager, User, Group
        
        if(forOperation.equalsIgnoreCase("ListTitlesLikeMGR")) {
//            StringBuffer query = new StringBuffer("SELECT DOC_ID,PARENT_ID,DOC_TITLE,ACCOUNT,ACCNT_ITEM_NAME,DESCRIPTION,TOTAL,DOC_STORAGE,FILE_NAME,SOUND,DOC_DATE,DOC_META_TYPE,CREATED_BY,CREATED_BY_NAME,GROUP_NAME,DOC_TYPE,STRUCTURE_TYPE,CREATION_TIME,IS_BASELINE,IS_LAST_BASELINE,IS_HIDDEN,DISPLAY_STATUS,SW_DOC_TYPE,CONFIG_ITEM_TYPE,VERSION_NUMBER,MODIFIED_BY,REVIEWED_BY,APPROVED_BY,RELEASE_DATE,IS_LOCKED FROM document WHERE IS_HIDDEN = \"FALSE\" AND ");
//            query.append("doc_title LIKE '%").append(param).append("%'").append(" AND ACCOUNT <> 'system' ");
//            query.append(" ORDER BY CREATION_TIME");
            return sqlMgr.getSql("selectListAllContextQuery").trim().replace("PPP", param);
        }
        
        if(forOperation.equalsIgnoreCase("ListDoc")) {
//            StringBuffer query = new StringBuffer("SELECT DOC_ID,DOC_TITLE,ISSUE_ID,DESCRIPTION,DOC_DATE,CREATED_BY,CREATED_BY_NAME,DOC_META_TYPE,DOC_TYPE,CONFIG_ITEM_TYPE,CREATION_TIME FROM document ");
//            query.append("WHERE ISSUE_ID = ? ");
            return sqlMgr.getSql("selectListDocQuery").trim();
        }
        
        
        if(forOperation.equalsIgnoreCase("ListTitlesLikeUSR")) {
//            StringBuffer query = new StringBuffer("SELECT DOC_ID,PARENT_ID,DOC_TITLE,ACCOUNT,ACCNT_ITEM_NAME,DESCRIPTION,TOTAL,DOC_STORAGE,FILE_NAME,SOUND,DOC_DATE,DOC_META_TYPE,CREATED_BY,CREATED_BY_NAME,GROUP_NAME,DOC_TYPE,STRUCTURE_TYPE,CREATION_TIME,IS_BASELINE,IS_LAST_BASELINE,IS_HIDDEN,DISPLAY_STATUS,SW_DOC_TYPE,CONFIG_ITEM_TYPE,VERSION_NUMBER,MODIFIED_BY,REVIEWED_BY,APPROVED_BY,RELEASE_DATE,IS_LOCKED FROM document WHERE IS_HIDDEN = \"FALSE\" AND");
//            query.append(" CREATED_BY ='").append(sessionUser.getAttribute("userId"));
//            query.append("' AND doc_title LIKE '%").append(param).append("%'").append(" AND ACCOUNT <> 'system' ");
//            query.append(" ORDER BY CREATION_TIME");
            return sqlMgr.getSql("selectListTitlesLikeUSRQuery").trim().replace("$", sessionUser.getAttribute("userId").toString()).replace("PPP", param);
        }
        
        if(forOperation.equalsIgnoreCase("ListTitlesLikeGRP")) {
//            StringBuffer query = new StringBuffer("SELECT DOC_ID,PARENT_ID,DOC_TITLE,ACCOUNT,ACCNT_ITEM_NAME,DESCRIPTION,TOTAL,DOC_STORAGE,FILE_NAME,SOUND,DOC_DATE,STRUCTURE_TYPE,DOC_META_TYPE,CREATED_BY,CREATED_BY_NAME,GROUP_NAME,DOC_TYPE,CREATION_TIME,IS_BASELINE,IS_LAST_BASELINE,IS_HIDDEN,DISPLAY_STATUS,SW_DOC_TYPE,CONFIG_ITEM_TYPE,VERSION_NUMBER,MODIFIED_BY,REVIEWED_BY,APPROVED_BY,RELEASE_DATE,IS_LOCKED FROM document WHERE IS_HIDDEN = \"FALSE\" AND");
//            query.append(" GROUP_NAME ='").append(sessionUser.getAttribute("groupName")).append("' AND ACCOUNT <> 'system' ");
//            query.append(" AND doc_title LIKE '%").append(param).append("%'");
//            query.append(" ORDER BY CREATION_TIME");
            return sqlMgr.getSql("selectListTitlesLikeGRPQuery").trim().replace("$", sessionUser.getAttribute("groupName").toString()).replace("PPP", param);
        }
        // ----------------------------------------------------------------------------------------------------------------
        
        //
        //        if(forOperation.equalsIgnoreCase("ListByLIKEContext")) {
        //            StringBuffer query = new StringBuffer("SELECT DOC_ID,DOC_TITLE,ACCOUNT,ACCNT_ITEM_NAME,DESCRIPTION,TOTAL,DOC_STORAGE,FILE_NAME,SOUND,DOC_DATE,CREATED_BY,CREATED_BY_NAME,GROUP_NAME,DOC_TYPE,CREATION_TIME FROM document WHERE ");
        //            query.append("doc_title LIKE '%").append(param).append("%'");
        //            query.append("AND CREATED_BY =").append(sessionUser.getAttribute("userId"));
        //            query.append(" ORDER BY ACCOUNT,ACCNT_ITEM_NAME,DOC_DATE");
        //            return query.toString();
        //        }
        // body search ......
        
        if(forOperation.equalsIgnoreCase("DBSearchMGR")) {
//            StringBuffer query = new StringBuffer("SELECT DOC_ID,PARENT_ID,DOC_TITLE,ACCOUNT,ACCNT_ITEM_NAME,DESCRIPTION,TOTAL,STRUCTURE_TYPE,DOC_STORAGE,FILE_NAME,SOUND,DOC_DATE,DOC_META_TYPE,CREATED_BY,CREATED_BY_NAME,GROUP_NAME,DOC_TYPE,CREATION_TIME,IS_BASELINE,IS_LAST_BASELINE,IS_HIDDEN,DISPLAY_STATUS,SW_DOC_TYPE,CONFIG_ITEM_TYPE,VERSION_NUMBER,MODIFIED_BY,REVIEWED_BY,APPROVED_BY,RELEASE_DATE,IS_LOCKED FROM document WHERE IS_HIDDEN = \"FALSE\" AND ");
//            query.append("IMAGE LIKE '%").append(param).append("%'");
//            query.append(" AND (DOC_META_TYPE = 'text')");
//            query.append(" ORDER BY CREATION_TIME");
            return sqlMgr.getSql("selectDBSearchMGRQuery").trim().replace("PPP", param);
        }
        
        if(forOperation.equalsIgnoreCase("DBSearchUSR")) {
//            StringBuffer query = new StringBuffer("SELECT DOC_ID,PARENT_ID,DOC_TITLE,ACCOUNT,ACCNT_ITEM_NAME,DESCRIPTION,TOTAL,STRUCTURE_TYPE,DOC_STORAGE,FILE_NAME,SOUND,DOC_DATE,DOC_META_TYPE,CREATED_BY,CREATED_BY_NAME,GROUP_NAME,DOC_TYPE,CREATION_TIME,IS_BASELINE,IS_LAST_BASELINE,IS_HIDDEN,DISPLAY_STATUS,SW_DOC_TYPE,CONFIG_ITEM_TYPE,VERSION_NUMBER,MODIFIED_BY,REVIEWED_BY,APPROVED_BY,RELEASE_DATE,IS_LOCKED FROM document WHERE IS_HIDDEN = \"FALSE\" AND ");
//            query.append("IMAGE LIKE '%").append(param).append("%'");
//            query.append(" AND CREATED_BY =").append(sessionUser.getAttribute("userId"));
//            query.append(" AND (DOC_META_TYPE = 'text')");
//            query.append(" ORDER BY CREATION_TIME");
            return sqlMgr.getSql("selectListTitlesLikeGRPQuery").trim().replace("$", sessionUser.getAttribute("userId").toString()).replace("PPP", param);
        }
        
        if(forOperation.equalsIgnoreCase("DBSearchGRP")) {
//            StringBuffer query = new StringBuffer("SELECT DOC_ID,PARENT_ID,DOC_TITLE,ACCOUNT,ACCNT_ITEM_NAME,DESCRIPTION,TOTAL,DOC_STORAGE,FILE_NAME,STRUCTURE_TYPE,SOUND,DOC_DATE,DOC_META_TYPE,CREATED_BY,CREATED_BY_NAME,GROUP_NAME,DOC_TYPE,CREATION_TIME,IS_BASELINE,IS_LAST_BASELINE,IS_HIDDEN,DISPLAY_STATUS,SW_DOC_TYPE,CONFIG_ITEM_TYPE,VERSION_NUMBER,MODIFIED_BY,REVIEWED_BY,APPROVED_BY,RELEASE_DATE,IS_LOCKED FROM document WHERE IS_HIDDEN = \"FALSE\" AND");
//            query.append(" ACCOUNT <> 'system' ").append("AND IMAGE LIKE '%").append(param).append("%'");
//            query.append("AND GROUP_NAME='").append(sessionUser.getAttribute("groupName"));
//            query.append("' AND (DOC_META_TYPE = 'text')");
//            query.append(" ORDER BY CREATION_TIME");
            return sqlMgr.getSql("selectListTitlesLikeGRPQuery").trim().replace("$", sessionUser.getAttribute("groupName").toString()).replace("PPP", param);
        }
        
        // get documents for account in specific time range
        
        if(forOperation.equalsIgnoreCase("ListAccountGRP")) {
//            StringBuffer query = new StringBuffer("SELECT DOC_ID,PARENT_ID,DOC_TITLE,ACCOUNT,ACCNT_ITEM_NAME,DESCRIPTION,TOTAL,DOC_STORAGE,FILE_NAME,SOUND,STRUCTURE_TYPE,DOC_DATE,DOC_META_TYPE,CREATED_BY,CREATED_BY_NAME,GROUP_NAME,DOC_TYPE,CREATION_TIME,IS_BASELINE,IS_LAST_BASELINE,IS_HIDDEN,DISPLAY_STATUS,SW_DOC_TYPE,CONFIG_ITEM_TYPE,VERSION_NUMBER,MODIFIED_BY,REVIEWED_BY,APPROVED_BY,RELEASE_DATE,IS_LOCKED FROM document ");
//            query.append("WHERE (DOC_DATE BETWEEN ? AND ?) AND ACC_ITEM_SURROGATE = ?  AND ACCOUNT <> 'system' ");
//            query.append("AND GROUP_NAME= '").append(sessionUser.getAttribute("groupName"));
//            query.append("' AND IS_HIDDEN = \"FALSE\" ORDER BY CREATION_TIME");
            return sqlMgr.getSql("selectListTitlesLikeGRPQuery").trim().replace("$", sessionUser.getAttribute("groupName").toString());
        }
        
        // get documents in range without restriction
        if(forOperation.equalsIgnoreCase("ListAccountAll")) {
            
//            return "SELECT DOC_ID,PARENT_ID,DOC_TITLE,ACCOUNT,ACCNT_ITEM_NAME,DESCRIPTION,TOTAL,DOC_STORAGE,FILE_NAME,SOUND,DOC_DATE,STRUCTURE_TYPE,DOC_META_TYPE,CREATED_BY,CREATED_BY_NAME,GROUP_NAME,DOC_TYPE,CREATION_TIME,IS_BASELINE,IS_LAST_BASELINE,IS_HIDDEN,DISPLAY_STATUS,SW_DOC_TYPE,CONFIG_ITEM_TYPE,VERSION_NUMBER,MODIFIED_BY,REVIEWED_BY,APPROVED_BY,RELEASE_DATE,IS_LOCKED FROM document WHERE IS_HIDDEN = \"FALSE\" AND (DOC_DATE BETWEEN ? AND ?) AND ACC_ITEM_SURROGATE = ?  ORDER BY CREATION_TIME ";
            return sqlMgr.getSql("selectListAccountAllQuery").trim();
        }
        
        if(forOperation.equalsIgnoreCase("ListAccountUSR")) {
//            StringBuffer query = new StringBuffer("SELECT DOC_ID,PARENT_ID,DOC_TITLE,ACCOUNT,ACCNT_ITEM_NAME,DESCRIPTION,TOTAL,STRUCTURE_TYPE,DOC_STORAGE,FILE_NAME,SOUND,DOC_DATE,DOC_META_TYPE,CREATED_BY,CREATED_BY_NAME,GROUP_NAME,DOC_TYPE,CREATION_TIME,IS_BASELINE,IS_LAST_BASELINE,IS_HIDDEN,DISPLAY_STATUS,SW_DOC_TYPE,CONFIG_ITEM_TYPE,VERSION_NUMBER,MODIFIED_BY,REVIEWED_BY,APPROVED_BY,RELEASE_DATE,IS_LOCKED FROM document ");
//            query.append("WHERE IS_HIDDEN = \"FALSE\" AND (DOC_DATE BETWEEN ? AND ?) AND ACC_ITEM_SURROGATE = ? ");
//            query.append("AND CREATED_BY ='").append(sessionUser.getAttribute("userId"));
//            query.append("' ORDER BY CREATION_TIME");
            return sqlMgr.getSql("selectListAccountUSRQuery").trim().replace("$", sessionUser.getAttribute("userId").toString());
        }
        
        // docs in time interval for 3 security levels
        if(forOperation.equalsIgnoreCase("ListDocsInSpanAll")) {
//            StringBuffer query = new StringBuffer("SELECT DOC_ID,PARENT_ID,DOC_TITLE,ACCOUNT,ACCNT_ITEM_NAME,DESCRIPTION,STRUCTURE_TYPE,TOTAL,DOC_STORAGE,FILE_NAME,SOUND,DOC_DATE,DOC_META_TYPE,CREATED_BY,CREATED_BY_NAME,GROUP_NAME,DOC_TYPE,CREATION_TIME,IS_BASELINE,IS_LAST_BASELINE,IS_HIDDEN,DISPLAY_STATUS,SW_DOC_TYPE,CONFIG_ITEM_TYPE,VERSION_NUMBER,MODIFIED_BY,REVIEWED_BY,APPROVED_BY,RELEASE_DATE,IS_LOCKED FROM document WHERE IS_HIDDEN = \"FALSE\" AND DOC_DATE BETWEEN ? AND ?");
//            query.append(" AND ACCOUNT <> 'system' ");
//            query.append(" ORDER BY CREATION_TIME");
            return sqlMgr.getSql("selectListDocsInSpanAllQuery").trim();
        }
        
        if(forOperation.equalsIgnoreCase("ListDocsInSpanGRP")) {
//            StringBuffer query = new StringBuffer("SELECT DOC_ID,PARENT_ID,DOC_TITLE,ACCOUNT,ACCNT_ITEM_NAME,DESCRIPTION,STRUCTURE_TYPE,TOTAL,DOC_STORAGE,FILE_NAME,SOUND,DOC_DATE,DOC_META_TYPE,CREATED_BY,CREATED_BY_NAME,GROUP_NAME,DOC_TYPE,CREATION_TIME,IS_BASELINE,IS_LAST_BASELINE,IS_HIDDEN,DISPLAY_STATUS,SW_DOC_TYPE,CONFIG_ITEM_TYPE,VERSION_NUMBER,MODIFIED_BY,REVIEWED_BY,APPROVED_BY,RELEASE_DATE,IS_LOCKED FROM document WHERE IS_HIDDEN = \"FALSE\" AND DOC_DATE BETWEEN ? AND ?");
//            query.append(" AND ACCOUNT <> 'system' ").append(" AND GROUP_NAME= '").append(sessionUser.getAttribute("groupName"));
//            query.append("' ORDER BY CREATION_TIME");
            return sqlMgr.getSql("selectListDocsInSpanGRPQuery").trim().replace("$", sessionUser.getAttribute("groupName").toString());
        }
        
        if(forOperation.equalsIgnoreCase("ListDocsInSpanUSR")) {
//            StringBuffer query = new StringBuffer("SELECT DOC_ID,PARENT_ID,DOC_TITLE,ACCOUNT,ACCNT_ITEM_NAME,DESCRIPTION,TOTAL,STRUCTURE_TYPE,DOC_STORAGE,FILE_NAME,SOUND,DOC_DATE,DOC_META_TYPE,CREATED_BY,CREATED_BY_NAME,GROUP_NAME,DOC_TYPE,CREATION_TIME,IS_BASELINE,IS_LAST_BASELINE,IS_HIDDEN,DISPLAY_STATUS,SW_DOC_TYPE,CONFIG_ITEM_TYPE,VERSION_NUMBER,MODIFIED_BY,REVIEWED_BY,APPROVED_BY,RELEASE_DATE,IS_LOCKED FROM document WHERE IS_HIDDEN = \"FALSE\" AND DOC_DATE BETWEEN ? AND ?");
//            query.append(" AND ACCOUNT <> 'system' ").append("AND CREATED_BY ='").append(sessionUser.getAttribute("userId"));
//            query.append("' ORDER BY CREATION_TIME");
            return sqlMgr.getSql("selectListDocsInSpanUSRQuery").trim().replace("$", sessionUser.getAttribute("userId").toString());
        }
        
        if(forOperation.equalsIgnoreCase("FilterOnType")) {
//            StringBuffer query = new StringBuffer("SELECT DOC_ID,PARENT_ID,DOC_TITLE,ACCOUNT,ACCNT_ITEM_NAME,DESCRIPTION,TOTAL,DOC_STORAGE,STRUCTURE_TYPE,FILE_NAME,SOUND,DOC_DATE,DOC_META_TYPE,CREATED_BY,CREATED_BY_NAME,GROUP_NAME,DOC_TYPE,CREATION_TIME,IS_BASELINE,IS_LAST_BASELINE,IS_HIDDEN,DISPLAY_STATUS,SW_DOC_TYPE,CONFIG_ITEM_TYPE,VERSION_NUMBER,MODIFIED_BY,REVIEWED_BY,APPROVED_BY,RELEASE_DATE,IS_LOCKED FROM document WHERE IS_HIDDEN = \"FALSE\" AND ");
//            query.append("DOC_TYPE = ").append("'").append(param).append("'");
//            query.append(" ORDER BY CREATION_TIME");
            return sqlMgr.getSql("selectFilterOnTypeQuery").trim().replace("PPP", param);
        }
        
        if(forOperation.equalsIgnoreCase("ListSptr")) {
//            StringBuffer query = new StringBuffer("SELECT DOC_ID,PARENT_ID,DOC_TITLE,ACCOUNT,ACCNT_ITEM_NAME,DESCRIPTION,TOTAL,DOC_STORAGE,STRUCTURE_TYPE,FILE_NAME,SOUND,DOC_DATE,DOC_META_TYPE,CREATED_BY,CREATED_BY_NAME,GROUP_NAME,DOC_TYPE,CREATION_TIME,IS_BASELINE,IS_LAST_BASELINE,IS_HIDDEN,DISPLAY_STATUS,SW_DOC_TYPE,CONFIG_ITEM_TYPE,VERSION_NUMBER,MODIFIED_BY,REVIEWED_BY,APPROVED_BY,RELEASE_DATE,IS_LOCKED FROM document WHERE ");
//            query.append("PARENT_ID = ").append("'").append(param).append("'");
//            query.append(" ORDER BY CREATION_TIME");
            return sqlMgr.getSql("selectListSptrQuery").trim().replace("PPP", param);
        }
        
        if(forOperation.equalsIgnoreCase("ListSptrUser")) {
            ImageMgr imageMgr = ImageMgr.getInstance();
            String maxDate = imageMgr.getMaxCreationDateForSep(param, true);
//            StringBuffer query = new StringBuffer("SELECT DOC_ID,PARENT_ID,DOC_TITLE,ACCOUNT,ACCNT_ITEM_NAME,DESCRIPTION,TOTAL,DOC_STORAGE,STRUCTURE_TYPE,FILE_NAME,SOUND,DOC_DATE,DOC_META_TYPE,CREATED_BY,CREATED_BY_NAME,GROUP_NAME,DOC_TYPE,CREATION_TIME,IS_BASELINE,IS_LAST_BASELINE,IS_HIDDEN,DISPLAY_STATUS,SW_DOC_TYPE,CONFIG_ITEM_TYPE,VERSION_NUMBER,MODIFIED_BY,REVIEWED_BY,APPROVED_BY,RELEASE_DATE,IS_LOCKED FROM document WHERE ");
//            query.append("PARENT_ID = ").append("'").append(param).append("' AND creation_time = '").append(maxDate).append("'");
            return sqlMgr.getSql("selectListSptrQuery").trim().replace("PPP", param).replace("$", maxDate);
        }
        
        if(forOperation.equalsIgnoreCase("Publish")) {
//            StringBuffer query = new StringBuffer("SELECT DOC_ID,PARENT_ID,DOC_TITLE,ACCOUNT,ACCNT_ITEM_NAME,DESCRIPTION,TOTAL,DOC_STORAGE,STRUCTURE_TYPE,FILE_NAME,SOUND,DOC_DATE,DOC_META_TYPE,CREATED_BY,CREATED_BY_NAME,GROUP_NAME,DOC_TYPE,CREATION_TIME,IS_BASELINE,IS_LAST_BASELINE,IS_HIDDEN,DISPLAY_STATUS,SW_DOC_TYPE,CONFIG_ITEM_TYPE,VERSION_NUMBER,MODIFIED_BY,REVIEWED_BY,APPROVED_BY,RELEASE_DATE,IS_LOCKED FROM document WHERE IS_HIDDEN = \"FALSE\" AND ");
//            query.append("SW_DOC_TYPE = ").append("'").append(param).append("'");
//            query.append(" ORDER BY CREATION_TIME");
            return sqlMgr.getSql("selectPublishQuery").trim().replace("PPP", param);
        }
        
        return null;
    }
    public Vector getQueryVectorParam(String concatParams){
        return null;
    }
}
