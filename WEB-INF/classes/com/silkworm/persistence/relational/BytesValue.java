package com.silkworm.persistence.relational;



/**
 * This class represents a byte[] value used by the SQL tags.
 *
 * @author Walid Mohamed, Silkworm software
 * @version 1.0
 */
public class BytesValue extends Value {
    private byte[] value;

    public BytesValue(byte[] value) {
        this.value = value;
    }

    public byte[] getBytes() {
        return value;
    }

    public String getString() {
        return new String(value);
    }
}
