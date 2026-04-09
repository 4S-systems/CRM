package com.silkworm.util;

import java.text.*;
import java.util.*;

/**
 * This class contains static methods for working with
 * arrays.
 *
 * @author Walid Mohamed, Silkworm software
 * @version 1.0
 */
public class ArraySupport {

    /**
     * Returns true if the specified value matches one of the elements
     * in the specified array.
     *
     * @param array the array to test.
     * @param value the value to look for.
     * @return true if valid, false otherwise
     */
    public static boolean contains(String[] array, String value) {
        boolean isIncluded = false;

        if (array == null || value == null) {
            return false;
        }
        for (int i = 0; i < array.length; i++) {
            if (value.equals(array[i])) {
                isIncluded = true;
                break;
            }
        }
        return isIncluded;
    }
}
