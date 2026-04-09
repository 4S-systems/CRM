/*
 * BinaryString.java
 *
 * Created on January 4, 2004, 11:15 AM
 */

package com.silkworm.util;

/**
 *
 * @author  walid
 */
public class BinaryString {
    
    /** Creates a new instance of BinaryString */
    
    private String binaryString = null;
    public BinaryString(String bString) {
        
        binaryString = bString;
    }
    
    public String getCheckBoxState(int pos)
    {
     char c = binaryString.charAt(pos);
     
     return c=='1'?"CHECKED":"";
    
    }    
    
}
