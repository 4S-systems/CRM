/*
 * DocViewerVideoFileRenamePolicy.java
 *
 * Created on April 27, 2004, 10:43 PM
 */

package com.docviewer.servlets;

/**
 *
 * @author  walid
 */

import com.silkworm.servlets.multipart.*;
import java.io.*;
import com.silkworm.Exceptions.*;

import com.silkworm.persistence.relational.UniqueIDGen;

public class DocViewerVideoFileRenamePolicy implements FileRenamePolicy {
    
    private static String randFileName = null;
    int len = 0;
    
    public File rename(File f) throws IncorrectFileType{
        
        String fileName = f.getName();
        if(fileName.indexOf(".wav")==-1 && fileName.indexOf(".WAV")==-1)
            throw new IncorrectFileType();
        
        String randome = UniqueIDGen.getNextID();
        len = randome.length();
        randFileName = new String("ran" +  randome.substring(5,len) + ".wav");
        
        
        f = new File(f.getParent(),randFileName);
        f.delete();
        
        if (createNewFile(f)) {
            return f;
        }
        
        
        return f;
    }
    
    private boolean createNewFile(File f) {
        try {
            
            return f.createNewFile();
        }
        catch (IOException ignored) {
            return false;
        }
    }
    
    public static String getFileName() {
        return randFileName;
    }
    
    
}


