/*
 * AudioDocRendererFactory.java
 *
 * Created on May 2, 2004, 8:02 PM
 */

package com.docviewer.rendering;

/**
 *
 * @author  walid
 */
public class AudioDocRendererFactory {
    
    /** Creates a new instance of AudioDocRendererFactory */

   public static IRenderAudioDocument getRenderer(String docType)
   {
       if(docType.equalsIgnoreCase("audiodoc"))
         return new AudioRenderer(); 
       
        if(docType.equalsIgnoreCase("movdoc"))
         return new VideoRenderer();  
       return null;
   }    
    
}
