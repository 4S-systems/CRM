package com.silkworm.persistence.relational;



/**
 * This class represents a float column.
 *
 * @author Walid Mohamed, Silkworm software
 * @version 1.0
 */
public class FloatColumn extends Column {
    private float value;

    public FloatColumn(String name, float value) {
        super(name);
        this.value = value;
    }

    public float getFloat() {
        return value;
    }

    public String getString() {
        return String.valueOf(value);
    }
}
