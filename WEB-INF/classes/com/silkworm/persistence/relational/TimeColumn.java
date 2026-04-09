package com.silkworm.persistence.relational;

import java.sql.*;


/**
 * This class represents a Time column.
 *
 * @author Walid Mohamed, Silkworm software
 * @version 1.0
 */
public class TimeColumn extends Column {
    private Time value;

    public TimeColumn(String name, Time value) {
        super(name);
        this.value = value;
    }

    public Time getTime() {
        return value;
    }

    public String getString() {
        return value != null ? value.toString() : null;
    }
}
