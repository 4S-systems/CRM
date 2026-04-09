/*
 * EntryExistsException.java
 *
 * Created on May 7, 2004, 12:00 AM
 */

package com.silkworm.Exceptions;

/**
 *
 * @author  walid
 */
public class EntryExistsException extends Exception{
    
    /** Creates a new instance of EntryExistsException */
    public EntryExistsException() {
        super("Entry already exists in database");
    }
    
}
