/*
 * DocViewerFileRenamePolicy.java
 *
 * Created on March 27, 2004, 6:06 PM
 */

package com.docviewer.servlets;

import com.silkworm.servlets.multipart.*;
import java.io.*;
import com.silkworm.Exceptions.*;
import com.silkworm.util.UniqueIdGen;

/**
 *
 * @author  walid
 */
public class DocViewerFileRenamePolicy implements FileRenamePolicy {
    
    
    private String fileExt = null;
    private String desiredFileExt = null;
    private int dotPos = 0;
    
    private String originalFileName = null;
    
    private String renamedFileName = null;
    
    public File rename(File f) throws IncorrectFileType{
        
        originalFileName = f.getName();
        String fileName = f.getName();
        dotPos = fileName.indexOf(".");
        fileExt = fileName.substring(dotPos + 1);
        
        if(!fileExt.equalsIgnoreCase(desiredFileExt))
            throw new IncorrectFileType();
        
       //  renamedFileName ="up" + UniqueIdGen.getNextID() + "." + fileExt;
        
        renamedFileName = fileName;
        
        f = new File( f.getParent(),renamedFileName);
        f.delete();
        
        if (createNewFile(f)) {
            return f;
        }
        
        
        return f;
    }
    
    private boolean createNewFile(File f) {
        try {
            
            return f.createNewFile();
        } catch (IOException ignored) {
            return false;
        }
    }
    
    public void checkFileType(String desiredExt) throws com.silkworm.Exceptions.IncorrectFileType {
        if(!desiredExt.equalsIgnoreCase(fileExt)) {
            throw new IncorrectFileType("Chosen file does not match desired type");
            
        }
    }
    
    public String getFileName() {
        return renamedFileName;
    }
    
    public void setDesiredFileExt(String ext) {
        
        desiredFileExt = ext;
        
    }
    
    public String getOrginalFileName()
    {
        return originalFileName;
    }
    
}


