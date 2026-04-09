package com.silkworm.pagination;

public class FilterCondition {

    public FilterCondition(String fieldName, Object value, Operations operation) {
        this.fieldName = fieldName;
        this.value = value;
        this.operation = operation;
    }

    public String getFieldName() {
        return fieldName;
    }

    public void setFieldName(String fieldName) {
        this.fieldName = fieldName;
    }

    public Object getValue() {
        return value;
    }

    public void setValue(Object value) {
        this.value = value;
    }

    public Operations getOperation() {
        return operation;
    }

    public void setOperation(Operations operation) {
        this.operation = operation;
    }

    private String fieldName;
    private Object value;
    private Operations operation;
}
