package com.silkworm.persistence.relational;



/**
 * This class represents a boolean column.
 *
 * @author Walid Mohamed, Silkworm software
 * @version 1.0
 */
public class BooleanColumn extends Column {
    private boolean value;

    public BooleanColumn(String name, boolean value) {
        super(name);
        this.value = value;
    }

    public boolean getBoolean() {
        return value;
    }

    public String getString() {
        return String.valueOf(value);
    }
}
