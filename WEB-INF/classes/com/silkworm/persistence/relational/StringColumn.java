package com.silkworm.persistence.relational;



/**
 * This class represents a String column.
 *
 * @author Walid Mohamed, Silkworm
 * @version 1.0
 */
public class StringColumn extends Column {
    private String value;

    public StringColumn(String name, String value) {
        super(name);
        this.value = value;
    }

    public String getString() {
        return value;
    }
}
