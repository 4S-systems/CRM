/*
 * AudioRenderer.java
 *
 * Created on May 2, 2004, 7:31 PM
 */

package com.docviewer.rendering;

/**
 *
 * @author  walid
 */
public class AudioRenderer implements IRenderAudioDocument{
    
    /** Creates a new instance of AudioRenderer */
    public AudioRenderer() {
    }
    
    public String getAppletHeight() {
        return "20";
    }
    
    public String getAppletWidth() {
        return "350";
    }
    
    public String getDisplayHeader() {
        return "Audio";
    }
    
    public String getType() {
        return "Audio";
    }
    
}
