package com.silkworm.persistence.relational;



/**
 * This class represents a int column.
 *
 * @author Walid Mohamed, Silkworm software
 * @version 1.0
 */
public class IntColumn extends Column {
    private int value;

    public IntColumn(String name, int value) {
        super(name);
        this.value = value;
    }

    public int getInt() {
        return value;
    }

    public String getString() {
        return String.valueOf(value);
    }
}
