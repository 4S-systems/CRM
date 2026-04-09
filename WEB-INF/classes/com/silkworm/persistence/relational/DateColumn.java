package com.silkworm.persistence.relational;

import java.sql.*;


/**
 * This class represents a java.sql.Date column.
 *
 * @author Walid Mohamed, Silkworm software <hans@gefionsoftware.com>
 * @version 1.0
 */
public class DateColumn extends Column {
    private Date value;

    public DateColumn(String name, Date value) {
        super(name);
        this.value = value;
    }

    public Date getDate() {
        return value;
    }

    public String getString() {
        return value != null ? value.toString() : null;
    }
}
