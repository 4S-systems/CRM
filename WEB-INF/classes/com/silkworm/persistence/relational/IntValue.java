package com.silkworm.persistence.relational;



/**
 * This class represents a int value used by the SQL tags.
 *
 * @author Hans Bergsten, Gefion software <hans@gefionsoftware.com>
 * @version 1.0
 */
public class IntValue extends Value {
    private int value;

    public IntValue(int value) {
        this.value = value;
    }

    public IntValue(Integer value)
    {

     this.value = value.intValue();

    }

    public int getInt() {
        return value;
    }

    public String getString() {
        return String.valueOf(value);
    }
}
