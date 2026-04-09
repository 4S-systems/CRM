package com.silkworm.persistence.relational;

/**
 * This exception is thrown when trying to call a get method on an
 * instance of a Value subclass with a return type that's not supported
 * for the data type represented by the subclass.
 *
 * @author Walid Mohamed, Silkworm software <hans@gefionsoftware.com>
 * @version 1.0
 */
public class UnsupportedTypeException extends Exception {

    public UnsupportedTypeException(String message) {
        super(message);
    }
}
