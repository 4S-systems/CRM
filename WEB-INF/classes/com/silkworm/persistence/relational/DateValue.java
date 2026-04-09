package com.silkworm.persistence.relational;

import java.sql.*;


/**
 * This class represents a java.sql.Date value used by the SQL tags.
 *
 * @author Walid Mohamed, Silkworm software
 * @version 1.0
 */
public class DateValue extends Value {
    private Date value;

    public DateValue(Date value) {
        this.value = value;
    }

    public Date getDate() {
        return value;
    }

    public String getString() {
        return value.toString();
    }
}
