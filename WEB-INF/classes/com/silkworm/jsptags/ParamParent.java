package com.silkworm.jsptags;

/**
 * This interface must be implemented by all tag handlers that can
 * have ParamTag's in the body.
 *

 */
public interface ParamParent {
    /**
     * Adds a parameter name-value pair represented by the
     * embedded ParamTag. The value is URL encoded.
     */
    void addParam(String name, String value);
}
