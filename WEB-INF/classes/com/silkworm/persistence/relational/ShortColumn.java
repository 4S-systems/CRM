package com.silkworm.persistence.relational;



/**
 * This class represents a short column.
 *
 * @author Walid Mohamed, Silkworm software
 * @version 1.0
 */
public class ShortColumn extends Column {
    private short value;

    public ShortColumn(String name, short value) {
        super(name);
        this.value = value;
    }

    public short getShort() {
        return value;
    }

    public String getString() {
        return String.valueOf(value);
    }
}
