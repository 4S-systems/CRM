/*
 * BusinessException.java
 *
 * Created on August 17, 2008, 10:31 AM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.silkworm.Exceptions;

/**
 *
 * @author gamma1
 */
public class BusinessException extends Exception{
    
    /** Creates a new instance of BusinessException */
    
    public BusinessException(String message) {
        super(message);
    }
    public BusinessException() {
    }
    
}
