package com.silkworm.persistence.relational;



/**
 * This class represents a boolean value used by the SQL tags.
 *
 * @author Walid Mohamed, Silkworm software
 * @version 1.0
 */
public class BooleanValue extends Value {
    private boolean value;

    public BooleanValue(boolean value) {
        this.value = value;
    }

    public boolean getBoolean() {
        return value;
    }

    public String getString() {
        return String.valueOf(value);
    }
}
