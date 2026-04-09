package com.silkworm.util;

import java.text.*;
import java.util.*;

/**
 * This class contains a number of static methods that can be used to
 * validate the format of Strings, typically received as input from
 * a user, and to format values as Strings that can be used in
 * HTML output without causing interpretation problems.
 *
 * @author Walid Mohamed, Silkworm software
 * @version 1.0
 */
public class swStringFormat {
    // Static format objects
    private static SimpleDateFormat dateFormat = new SimpleDateFormat();
    private static DecimalFormat numberFormat = new DecimalFormat();
    
 


    /**
     * Returns true if the specified date string represents a valid
     * date in the specified format.
     *
     * @param dateString a String representing a date/time.
     * @param dateFormatPattern a String specifying the format to be used
     *   when parsing the dateString. The pattern is expressed with the
     *   pattern letters defined for the java.text.SimpleDateFormat class.
     * @return true if valid, false otherwise
     */
    public static boolean isValidDate(String dateString, String dateFormatPattern) {
        Date validDate = null;
        synchronized (dateFormat) {
            try {
                dateFormat.applyPattern(dateFormatPattern);
                dateFormat.setLenient(false);
                validDate = dateFormat.parse(dateString);
            }
            catch (ParseException e) {
                // Ignore and return null
            }
        }
        return validDate != null;
    }

    /**
     * Returns true if the specified number string represents a valid
     * integer in the specified range.
     *
     * @param numberString a String representing an integer
     * @param min the minimal value in the valid range
     * @param min the maximal value in the valid range
     * @return true if valid, false otherwise
     */
    public static boolean isValidInteger(String numberString, int min, int max) {
        Integer validInteger = null;
        try {
            Number aNumber = numberFormat.parse(numberString);
            int anInt = aNumber.intValue();
            if (anInt >= min && anInt <= max) {
                validInteger = new Integer(anInt);
            }
        }
        catch (ParseException e) {
            // Ignore and return null
        }
        return validInteger != null;
    }
/*
    public static boolean isValidFloat(String numberString, float min, float max)
    {
        Float validFloat = null;
        try {
            Number aNumber = numberFormat.parse(numberString);
            float aFloat = aNumber.floatValue();
            if (aFloat >= min && aFloat <= max) {
                validFloat = new Float(aFloat);
            }
        }
        catch (ParseException e) 
        {
            // Ignore and return null
        }
        return validFloat != null;
    }
  */
    
    
  public static boolean isValidFloat(String numberString, float min, float max)
    {
        Float validFloat = null;
        try {
            Float c = new Float(numberString);
            float aFloat = c.floatValue();
            if (aFloat >= min && aFloat <= max) {
                validFloat = new Float(aFloat);
            }
        }
        catch (Exception e) 
        {
            // Ignore and return null
        }
        return validFloat != null;
    }      
    /**
     * Returns true if the email string contains an at sign ("@") and
     * at least one dot ("."), i.e. "hans@gefionsoftware.com" is accepted
     * but "hans@gefionsoftware" is not. Note! This rule is not always
     * correct (e.g. on an intranet it may be okay with just a name) and
     * does not gurantee a valid Internet email address but it takes
     * care of the most obvious Internet mail address format errors.
     *
     * @param emailAddrString a String representing an email address
     * @return true if valid, false otherwise
     */
    public static boolean isValidEmailAddr(String emailAddrString) {
        boolean isValid = false;
        if (emailAddrString != null &&
            emailAddrString.indexOf("@") != -1 &&
            emailAddrString.indexOf(".") != -1) {
            isValid = true;
        }
        return isValid;
    }

    /**
     * Returns true if the specified string matches a string in the set
     * of provided valid strings, ignoring case if specified.
     *
     * @param value the String validate
     * @param validStrings an array of valid Strings
     * @param ignoreCase if true, case is ignored when comparing the value
     *  to the set of validStrings
     * @return true if valid, false otherwise
     */
    public static boolean isValidString(String value, String[] validStrings,
            boolean ignoreCase) {
        boolean isValid = false;
        for (int i = 0; validStrings != null && i < validStrings.length; i++) {
            if (ignoreCase) {
                if (validStrings[i].equalsIgnoreCase(value)) {
                    isValid = true;
                    break;
                }
            }
            else {
                if (validStrings[i].equals(value)) {
                    isValid = true;
                    break;
                }
            }
        }
        return isValid;
    }

    /**
     * Returns the specified string converted to a format suitable for
     * HTML. All signle-quote, double-quote, greater-than, less-than and
     * ampersand characters are replaces with their corresponding HTML
     * Character Entity code.
     *
     * @param in the String to convert
     * @return the converted String
     */
    public static String toHTMLString(String in) {
        in = in.trim();
        StringBuffer out = new StringBuffer();
        for (int i = 0; in != null && i < in.length(); i++) {
            char c = in.charAt(i);
            if (c == '\'') {
                out.append("&#39;");
            }
            else if (c == '\"') {
                out.append("&#34;");
            }
            else if (c == '<') {
                out.append("&lt;");
            }
            else if (c == '>') {
                out.append("&gt;");
            }
            else if (c == '&') {
                out.append("&amp;");
            }
            else {
                out.append(c);
            }
        }
        return out.toString();
    }

    /**
     * Converts a String to a Date, using the specified pattern.
     * (see java.text.SimpleDateFormat for pattern description)
     *
     * @param dateString the String to convert
     * @param dateFormatPattern the pattern
     * @return the corresponding Date
     * @exception ParseException, if the String doesn't match the pattern
     */
    public static Date toDate(String dateString, String dateFormatPattern)
        throws ParseException {
        Date date = null;
        if (dateFormatPattern == null) {
            dateFormatPattern = "yyyy-MM-dd";
        }
        synchronized (dateFormat) {
            dateFormat.applyPattern(dateFormatPattern);
            dateFormat.setLenient(false);
            date = dateFormat.parse(dateString);
        }
        return date;
    }

    /**
     * Converts a String to a Number, using the specified pattern.
     * (see java.text.NumberFormat for pattern description)
     *
     * @param numString the String to convert
     * @param numFormatPattern the pattern
     * @return the corresponding Number
     * @exception ParseException, if the String doesn't match the pattern
     */
    public static Number toNumber(String numString, String numFormatPattern)
        throws ParseException {
        Number number = null;
        if (numFormatPattern == null) {
            numFormatPattern = "######.##";
        }
        synchronized (numberFormat) {
            numberFormat.applyPattern(numFormatPattern);
            number = numberFormat.parse(numString);
        }
        return number;
    }

    /**
     * Replaces one string with another throughout a source string.
     *
     * @param in the source String
     * @param from the sub String to replace
     * @param to the sub String to replace with
     * @return a new String with all occurences of from replaced by to
     */
    public static String replaceInString(String in, String from, String to) {
        if (in == null || from == null || to == null) {
            return in;
        }

        StringBuffer newValue = new StringBuffer();
        char[] inChars = in.toCharArray();
        int inLen = inChars.length;
        char[] fromChars = from.toCharArray();
        int fromLen = fromChars.length;

        for (int i = 0; i < inLen; i++) {
            if (inChars[i] == fromChars[0] && (i + fromLen) <= inLen) {
                boolean isEqual = true;
                for (int j = 1; j < fromLen; j++) {
                    if (inChars[i + j] != fromChars[j]) {
                        isEqual = false;
                        break;
                    }
                }
                if (isEqual) {
                    newValue.append(to);
                    i += fromLen - 1;
                }
                else {
                    newValue.append(inChars[i]);
                }
            }
            else {
                newValue.append(inChars[i]);
            }
        }
        return newValue.toString();
    }
}
