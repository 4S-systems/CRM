package com.silkworm.persistence.relational;



/**
 * This class represents a long column.
 *
 * @author Walid Mohamed, Silkworm software
 * @version 1.0
 */
public class LongColumn extends Column {
    private long value;

    public LongColumn(String name, long value) {
        super(name);
        this.value = value;
    }

    public long getLong() {
        return value;
    }

    public String getString() {
        return String.valueOf(value);
    }
}
