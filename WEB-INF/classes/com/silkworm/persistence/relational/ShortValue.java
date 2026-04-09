package com.silkworm.persistence.relational;



/**
 * This class represents a short value used by the SQL tags.
 *
 * @author Hans Bergsten, Gefion software <hans@gefionsoftware.com>
 * @version 1.0
 */
public class ShortValue extends Value {
    private short value;

    public ShortValue(short value) {
        this.value = value;
    }

    public short getShort() {
        return value;
    }

    public String getString() {
        return String.valueOf(value);
    }
}
