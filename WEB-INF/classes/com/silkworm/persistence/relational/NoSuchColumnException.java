package com.silkworm.persistence.relational;

/**
 * This exception is thrown when trying to get a column from a Row
 * using an invalid index or name.
 *
 * @author Walid Mohamed, Silkworm software
 * @version 1.0
 */
public class NoSuchColumnException extends Exception {

    public NoSuchColumnException(String message) {
        super(message);
    }
}
