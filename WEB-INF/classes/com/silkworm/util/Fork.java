/*
 * Fork.java
 *
 * Created on February 11, 2005, 6:19 AM
 */
package com.silkworm.util;

import java.io.*;
import java.util.ArrayList;
import com.silkworm.Exceptions.*;



/**
 *
 * @author  Walid
 */
public class Fork {
    
    /** Creates a new instance of Fork */
    public Fork() {
    }
    
    static public String[] runCommand(String cmd) throws InterruptedException, IOException,UbnormalProcessTerminationEx {
        
        // set up list to capture command output lines
        
        ArrayList list = new ArrayList();
        
        // start command running
        
        Process proc = Runtime.getRuntime().exec(cmd);
        
        // get command's output stream and
        // put a buffered reader input stream on it
        
        InputStream istr = proc.getInputStream();
        BufferedReader br =
        new BufferedReader(new InputStreamReader(istr));
        
        // read output lines from command
        
        String str;
        while ((str = br.readLine()) != null)
            list.add(str);
        
        // wait for command to terminate
        
        try {
            proc.waitFor();
        }
        catch (InterruptedException inturrptedEx) {
            System.err.println("process was interrupted");
            throw inturrptedEx;
        }
        
        // check its exit value
        
        if (proc.exitValue() != 0) {
            System.err.println("exit value was non-zero");
            br.close();
            throw new UbnormalProcessTerminationEx("Process Inturrupted");
            
        }
        // close stream
        
        br.close();
        
        // return list of strings to caller
        
        return (String[])list.toArray(new String[0]);
    }
    
    
}
