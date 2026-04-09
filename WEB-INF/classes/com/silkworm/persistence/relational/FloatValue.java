package com.silkworm.persistence.relational;



/**
 * This class represents a float value used by the SQL tags.
 *
 * @author Hans Bergsten, Gefion software <hans@gefionsoftware.com>
 * @version 1.0
 */
public class FloatValue extends Value {
    private float value;

    public FloatValue(float value) {
        this.value = value;
    }

    public float getFloat() {
        return value;
    }

    public String getString() {
        return String.valueOf(value);
    }
}
