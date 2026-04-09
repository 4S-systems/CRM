/*
 * Folder.java
 *
 * Created on March 30, 2005, 1:52 PM
 */

package com.docviewer.business_objects;

/**
 *
 * @author Walid
 */


import java.util.*;
import com.silkworm.business_objects.*;
import java.io.Serializable;
import com.silkworm.common.MetaDataMgr;

public class Folder extends ContainerDocument implements Serializable {
    
      MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    public Folder(Hashtable ht) {
        super(ht);
        
    }
    
    public Folder(Document doc) {
        
        super(doc);
      
     //   tGuide = new TouristGuide("/com/docviewer/international/DocOnlineMenu");
        
     
        
    }
    public String getChildListToMainPageLink() {
      
        
        return (  metaMgr.getContext() + "/FolderServlet?op=GetChildList&parentID=" + (String) getAttribute("docID"));
    }
}
