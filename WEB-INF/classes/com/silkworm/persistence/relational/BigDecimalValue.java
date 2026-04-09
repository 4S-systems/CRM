package com.silkworm.persistence.relational;

import java.math.*;


/**
 * This class represents a BigDecimal value used by the SQL tags.
 *
 * @author Walid Mohamed, Silkworm software
 * @version 1.0
 */
public class BigDecimalValue extends Value {
    private BigDecimal value;

    public BigDecimalValue(BigDecimal value) {
        this.value = value;
    }

    public BigDecimal getBigDecimal() {
        return value;
    }

    public String getString() {
        return value.toString();
    }
}