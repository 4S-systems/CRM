package com.silkworm.persistence.relational;

import java.sql.*;


/**
 * This class represents a Timestamp value used by the SQL tags.
 *
 * @author Walid Mohamed, Silkworm software
 * @version 1.0
 */
public class TimestampValue extends Value {
    private Timestamp value;

    public TimestampValue(Timestamp value) {
        this.value = value;
    }

    public Timestamp getTimestamp() {
        return value;
    }

    public String getString() {
        return value.toString();
    }
}
