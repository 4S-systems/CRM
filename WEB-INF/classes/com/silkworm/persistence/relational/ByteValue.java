package com.silkworm.persistence.relational;



/**
 * This class represents a byte value used by the SQL tags.
 *
 * @author Walid Mohamed, Silkworm software
 * @version 1.0
 */
public class ByteValue extends Value {
    private byte value;

    public ByteValue(byte value) {
        this.value = value;
    }

    public byte getByte() {
        return value;
    }

    public String getString() {
        return String.valueOf(value);
    }
}
