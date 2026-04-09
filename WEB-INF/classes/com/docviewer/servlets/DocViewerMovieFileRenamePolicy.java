/*
 * DocViewerMovieFileRenamePolicy.java
 *
 * Created on April 28, 2004, 11:24 AM
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

public class DocViewerMovieFileRenamePolicy implements FileRenamePolicy {
    
    private static String randFileName = null;
    int len = 0;
    
    public File rename(File f) throws IncorrectFileType{
        
        String fileName = f.getName();
        int dotpos = fileName.indexOf(".");
        String fileExt = fileName.substring(dotpos);
        
       if(fileName.indexOf(".mov")==-1 && fileName.indexOf(".MOV")==-1 && fileName.indexOf(".mpg")==-1 && fileName.indexOf(".MPG")==-1)
            throw new IncorrectFileType();
        
        
        String randome = UniqueIDGen.getNextID();
         len = randome.length();
         randFileName = new String("ran" +  randome.substring(5,len) + fileExt);
              
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
    
   public static String getFileName()
   {
    return randFileName;   
   }    
    
}