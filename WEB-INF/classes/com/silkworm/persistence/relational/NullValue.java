package com.silkworm.persistence.relational;

public class NullValue extends Value {

    public NullValue() { }

    public Object getValue() {
        return null;
    }

    @Override public String getString() {
        return null;
    }
}
