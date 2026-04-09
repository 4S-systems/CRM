package com.silkworm.persistence.relational;



/**
 * This class represents an Object column.
 *
 * @author Walid Mohamed, Silkworm software
 * @version 1.0
 */
public class ObjectColumn extends Column {
    private Object value;

    public ObjectColumn(String name, Object value) {
        super(name);
        this.value = value;
    }

    public Object getObject() {
        return value;
    }

    public String getString() {
        return value.toString();
    }
}
