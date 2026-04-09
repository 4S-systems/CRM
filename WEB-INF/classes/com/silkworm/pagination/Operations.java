package com.silkworm.pagination;

public enum Operations {
    EQUAL("=", "Equal"),
    NOT_EQUAL("!=", "Not equal"),
    GRETER_THAN(">", "Greter than"),
    LESS_THAN("<", "Less than"),
    GRETER_THAN_OR_EQUAL(">=", "Greter than or equal"),
    LESS_THAN_OR_EQUAL("<=", "Less than or equal"),
    LIKE("LIKE", "Like"),
    START_WITH("LIKE", "Start with"),
    END_WITH("LIKE", "End with"),
    CONTAIN("LIKE", "Contain"),
    IS_NULL("IS NULL", "Is null"),
    IS_NOT_NULL("IS NOT NULL", "Is not null"),
    IN("IN", "in"),
    NOTIN("NOT IN", "not in");

        Operations(String operation, String label) {
            this.operation = operation;
            this.label = label;
        }

        public String getOperation() {
            return operation;
        }

        public String getLabel() {
            return label;
        }

        private String operation;
        private String label;
}
