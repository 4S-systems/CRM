package com.silkworm.persistence.relational;



/**
 * This class represents a byte column.
 *
 * @author Hans Bergsten, Gefion software <hans@gefionsoftware.com>
 * @version 1.0
 */
public class ByteColumn extends Column {
    private byte value;

    public ByteColumn(String name, byte value) {
        super(name);
        this.value = value;
    }

    public byte getByte() {
        return value;
    }

    public String getString() {
        return String.valueOf(value);
    }
}
