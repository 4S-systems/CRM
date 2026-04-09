/*
 * VideoRenderer.java
 *
 * Created on May 2, 2004, 9:50 PM
 */

package com.docviewer.rendering;

/**
 *
 * @author  walid
 */
public class VideoRenderer implements IRenderAudioDocument{
    
    /** Creates a new instance of VideoRenderer */
    public VideoRenderer() {
    }
    
    public String getAppletHeight() {
        return "";
    }
    
    public String getAppletWidth() {
        return "";
    }
    
    public String getDisplayHeader() {
        return "Video";
    }
    
    public String getType() {
        return "Video"; 
    }
    
}
