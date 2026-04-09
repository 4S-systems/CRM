package com.silkworm.persistence.relational;

import java.sql.*;


/**
 * This class represents a Timestamp column.
 *
 * @author Walid Mohamed, Silkworm software
 * @version 1.0
 */
public class TimestampColumn extends Column {
    private Timestamp value;

    public TimestampColumn(String name, Timestamp value) {
        super(name);
        this.value = value;
    }

    public Timestamp getTimestamp() {
        return value;
    }

    public String getString() {
        return value != null ? value.toString() : null;
    }
}
