package com.silkworm.persistence.relational;

import java.math.*;


/**
 * This class represents a BigDecimal column.
 *
 * @author Walid Mohamed, Silkworm software
 * @version 1.0
 */
public class BigDecimalColumn extends Column {
    private BigDecimal value;

    public BigDecimalColumn(String name, BigDecimal value) {
        super(name);
        this.value = value;
    }

    public BigDecimal getBigDecimal() {
        return value;
    }

    public String getString() {
        return value != null ? value.toString() : null;
    }
}