/*
 * AppConstants.java
 *
 * Created on April 1, 2004, 3:03 AM
 */

package com.docviewer.common;

/**
 *
 * @author  walid
 */
import java.util.*;
import com.silkworm.international.TouristGuide;

public class DVAppConstants {
    
    
    
    private Properties mappedTitle = new Properties();
    private String[] userPref = null;
    private TouristGuide tGuide = null;
    
    private String[] docAttributes = {"docTitle","docDate","configItemType"};
    // private String[] docHeaders = {"Title","Account","Account Item","Date","Version Number","View Document","More Details","Delete","Bookmark","Baseline"};
    private String[] docHeaders = new String[9];
    
    
    public DVAppConstants(){
        
        
        tGuide = new TouristGuide("/com/docviewer/international/DocTitle");
        // tGuide.setBundlePath("/com/docviewer/international/DocTitle");
        // tGuide.setFrance();
        buildDocHeader();
        
        mappedTitle.setProperty("userName", "User Name");
        mappedTitle.setProperty("password", "Password");
        
        
    }
    public String[] getDocAttributes() {
        
        return  docAttributes;
    }
    
    public String[] getDocHeaders() {
        
        return  docHeaders;
    }
    
    public String getHeader(String attributeName) {
        return mappedTitle.getProperty(attributeName);
    }
    
    public static String getQury(String filter) {
        StringBuffer query = null;
        
        if(filter.equalsIgnoreCase("ListAll")) {
            query = new StringBuffer("SELECT DOC_ID,DOC_TITLE,ISSUE_ID,DESCRIPTION,DOC_TYPE,CREATED_BY,CREATED_BY_NAME,DOC_META_TYPE,CREATION_TIME FROM document");
//            query.append(" WHERE IS_HIDDEN = \"FALSE\"");
            query.append(" ORDER BY CREATION_TIME");
            return query.toString();
            
        }
        return null;
    }
    public static Object getFilterObject(String filter) {
        
        
        return new Object();
    }
    
    private void buildDocHeader() {
        Integer rank = null;
        System.out.println("----------------------------------   " + "Building doc header  ");
        
        for(int i=0;i<7;i++) {
            rank = new Integer(i);
            System.out.println("TITLE  ------------  " + tGuide.getMessage(rank.toString()));
            docHeaders[i] = tGuide.getMessage(rank.toString());
        }
        System.out.println(" I finished .......  ");
    }
}

