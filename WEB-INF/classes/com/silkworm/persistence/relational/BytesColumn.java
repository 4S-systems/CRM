package com.silkworm.persistence.relational;



/**
 * This class represents a byte[] column.
 *
 * @author Hans Walid Mohamed, Silkworm software
 * @version 1.0
 */
public class BytesColumn extends Column {
    private byte[] value;

    public BytesColumn(String name, byte[] value) {
        super(name);
        this.value = value;
    }

    public byte[] getBytes() {
        return value;
    }

    public String getString() {
        return new String(value);
    }
}
