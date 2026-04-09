package com.silkworm.persistence.relational;

import java.math.*;
import java.sql.*;

/**
 * This class represents a column in a row returned by a SQL query. It
 * contains default implementations of get methods for all supported types,
 * to avoid casting when using a concrete implementation. All default
 * implementations throw an UnsupportedConversionException.
 * <p>
 * Each subclass must override the getString() method, returning the
 * value as a String, plus the get method for the appropriate data
 * type, and provide a constructor to set the value.
 *
 * @author Walid Mohamed, Silkworm software
 * @version 1.0
 */
public abstract class Column {
    protected String name;

    public Column(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public BigDecimal getBigDecimal() throws UnsupportedConversionException {
        throw new UnsupportedConversionException("No conversion to BigDecimal");
    }

    public boolean getBoolean() throws UnsupportedConversionException {
        throw new UnsupportedConversionException("No conversion to boolean");
    }

    public byte getByte() throws UnsupportedConversionException {
        throw new UnsupportedConversionException("No conversion to byte");
    }

    public byte[] getBytes() throws UnsupportedConversionException {
        throw new UnsupportedConversionException("No conversion to byte[]");
    }

    public Date getDate() throws UnsupportedConversionException {
        throw new UnsupportedConversionException("No conversion to Date");
    }

    public double getDouble() throws UnsupportedConversionException {
        throw new UnsupportedConversionException("No conversion to double");
    }

    public float getFloat() throws UnsupportedConversionException {
        throw new UnsupportedConversionException("No conversion to float");
    }

    public int getInt() throws UnsupportedConversionException {
        throw new UnsupportedConversionException("No conversion to int");
    }

    public long getLong() throws UnsupportedConversionException {
        throw new UnsupportedConversionException("No conversion to long");
    }

    public short getShort() throws UnsupportedConversionException {
        throw new UnsupportedConversionException("No conversion to short");
    }

    /**
     * This method must be implemented by all subclasses.
     * All data types can be converted to a String.
     */
    public abstract String getString();

    public Time getTime() throws UnsupportedConversionException {
        throw new UnsupportedConversionException("No conversion to Time");
    }

    public Timestamp getTimestamp() throws UnsupportedConversionException {
        throw new UnsupportedConversionException("No conversion to Timestamp");
    }

    public Object getObject() throws UnsupportedConversionException {
        throw new UnsupportedConversionException("No conversion to Object");
    }

    public String toString() {
        return getString();
    }
}