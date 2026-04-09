package com.silkworm.persistence.relational;



/**
 * This class represents a double column.
 *
 * @author Walid Mohamed, Silkworm software
 * @version 1.0
 */
public class DoubleColumn extends Column {
    private double value;

    public DoubleColumn(String name, double value) {
        super(name);
        this.value = value;
    }

    public double getDouble() {
        return value;
    }

    public String getString() {
        return String.valueOf(value);
    }
}
