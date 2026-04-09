/*
 * IRenderDocument.java
 *
 * Created on May 2, 2004, 7:25 PM
 */

package com.docviewer.rendering;

/**
 *
 * @author  walid
 */
public interface IRenderAudioDocument {
    
    /** Creates a new instance of IRenderDocument */
   public String getDisplayHeader();
   public String getAppletWidth();
   public String getAppletHeight();
   public String getType();
    
}
