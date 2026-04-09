package com.silkworm.persistence.relational;

/**
 * This exception is thrown when trying to call a get method on an
 * instance of a Value subclass with a return type that's not supported
 * for the data type represented by the subclass.
 *
 * @author Walid Mohamed, Silkworm software
 * @version 1.0
 */
public class UnsupportedConversionException extends Exception {

    public UnsupportedConversionException(String message) {
        super(message);
    }
}
