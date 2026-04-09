/*
 * AppConstants.java
 *
 * Created on April 1, 2004, 3:03 AM
 */

package com.silkworm.common.bus_admin;

/**
 *
 * @author  walid
 */
import java.util.*;
import com.silkworm.international.TouristGuide;

public class AppConstants {
    
    
    private TouristGuide tGuide = null;
    private Properties mappedTitle = new Properties();
    private String[] userPref = null;
    
    private String[] userAttributes = {"userName","password", "fullName"};
    // private String[] usereHeaders = {"User Name.","Password","View","Edit","Delete"};
    private String[] usereHeaders = new String[8];
    
    private String[] groupAttributes = {"groupName"};
    //private String[] groupHeaders = {"Group Name","View","Edit","Delete"};
    private String[] groupHeaders = new String[5];
    
    private String[] accntAttributes = {"docTitle"};
    // private String[] accntHeaders = {"Account Name","Details","Delete","Bookmark","Account ID"};
    private String[] accntHeaders = new String[7];
    
    private String[] traceabAttributes = {"influencedTitle"};
    private String[] tracHeaders =  new String[3];
    
    private String[] classAttributes = {"classTitle"};
    // private String[] classHeaders = {"Class Name","Details","Delete"};
    private String[] classHeaders = new String[3];
    
    private String[] accntItemAttributes = {"docTitle"};
    
    private String[] currentUserAttributes = {"userName","userId","loginTime","sessionId","remoteAddress"};
    
   // private String[] accntItemHeaders = {"Separator Name","View","Edit","Delete","Move","Baseline","Last Baseline","Traceability","Traceabilities","Change Request"};
    private String[] accntItemHeaders =  new String[10];
    
    private String[] concurrentUsersHeaders =  new String[5];
    
    
    private String[] docTypeAttributes = {"typeName"};
    
    private String[] classicHeaders = new String[4];
    
    
    public AppConstants(){
        mappedTitle.setProperty("userName", "User Name");
        mappedTitle.setProperty("password", "Password");
        mappedTitle.setProperty("fullName", "Full Name");
        
        mappedTitle.setProperty("groupName", "Group Name");
        buildGroupListHeader();
        buildAccountListHeader();
        buildUserListHeader();
        buildClassListHeader();
        buildAccountItemListHeader();
        buildConcurrentUsersListHeader();
        buildClassicHeader();
        buildTracabListHeader();
        
    }
    
    public String[] getAccntItemAttributes() {
        
        return  accntItemAttributes;
    }
    
    public String[] getAccntItemHeaders() {
        
        return  accntItemHeaders;
    }
    
    
    
    
    
    
    public String[] getClassAttributes() {
        
        return  classAttributes;
    }
    
    public String[] getCurrentUserAttributes() {
        
        return  currentUserAttributes;
    }
    
    
    public String[] getClassHeaders() {
        
        return  classHeaders;
    }
    
    
    
    public String[] getAccntAttributes() {
        
        return  accntAttributes;
    }
    
    public String[] getAccntHeaders() {
        
        return  accntHeaders;
    }
    
    public String[] getDocTypeAttributes() {
        
        return docTypeAttributes;
    }
    
    public String[] getTraceabAttributes() {
        
        return  traceabAttributes;
    }
    
    public String[] getTracabHeaders() {
        
        return  tracHeaders;
    }
    
    public String[] getUserAttributes() {
        
        return  userAttributes;
    }
    
    public String[] getUserHeaders() {
        
        return  usereHeaders;
    }
    
    public String[] getGroupAttributes() {
        
        return  groupAttributes;
    }
    
    public String[] getGroupHeaders() {
        
        return groupHeaders;
    }
    
    
    public String[] getConcurrentUsersHeaders() {
        
        return concurrentUsersHeaders;
    }
    
    public String[] getClassicHeaders() {
        
        return classicHeaders;
    }
    
    public String getHeader(String attributeName) {
        return mappedTitle.getProperty(attributeName);
    }
    
    
    
    
    private void buildGroupListHeader() {
        Integer rank = null;
        tGuide = new TouristGuide("/com/docviewer/international/GroupTitle");
        
        for(int i=0;i<4;i++) {
            rank = new Integer(i);
            
            groupHeaders[i] = tGuide.getMessage(rank.toString());
        }
        
    }
    
    private void buildAccountListHeader() {
        Integer rank = null;
        tGuide = new TouristGuide("/com/docviewer/international/AccountTitle");
        
        for(int i=0;i<7;i++) {
            rank = new Integer(i);
            
            accntHeaders[i] = tGuide.getMessage(rank.toString());
        }
        
    }
    
    private void buildUserListHeader() {
        Integer rank = null;
        tGuide = new TouristGuide("/com/docviewer/international/UserTitle");
        
        for(int i=0;i<6;i++) {
            rank = new Integer(i);
            
            usereHeaders[i] = tGuide.getMessage(rank.toString());
        }
        
    }
    
    private void buildClassListHeader() {
        Integer rank = null;
        tGuide = new TouristGuide("/com/docviewer/international/ClassTitle");
        
        for(int i=0;i<3;i++) {
            rank = new Integer(i);
            
            classHeaders[i] = tGuide.getMessage(rank.toString());
        }
        
    }
    
    private void buildAccountItemListHeader() {
        Integer rank = null;
        tGuide = new TouristGuide("/com/docviewer/international/AccountClassTitle");
        
        for(int i=0;i<10;i++) {
            rank = new Integer(i);
            
            accntItemHeaders[i] = tGuide.getMessage(rank.toString());
        }
        
    }    
    
    private void buildConcurrentUsersListHeader() {
        Integer rank = null;
        tGuide = new TouristGuide("/com/silkworm/international/ConcurrentUsersTitles");
        
        for(int i=0;i<5;i++) {
            rank = new Integer(i);
            
            concurrentUsersHeaders[i] = tGuide.getMessage(rank.toString());
        }
        
    }
    
    private void buildClassicHeader() {
        Integer rank = null;
        tGuide = new TouristGuide("/com/silkworm/international/ClassicHeaders");
        
        for(int i=0;i<4;i++) {
            rank = new Integer(i);
            
            classicHeaders[i] = tGuide.getMessage(rank.toString());
        }
        
    }
    
    private void buildTracabListHeader() {
        Integer rank = null;
        tGuide = new TouristGuide("/com/docviewer/international/TracabClassTitle");
        
        for(int i=0;i<3;i++) {
            rank = new Integer(i);
            
            tracHeaders[i] = tGuide.getMessage(rank.toString());
        }
        
    }
    
}

