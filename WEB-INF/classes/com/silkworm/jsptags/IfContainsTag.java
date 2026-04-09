package com.silkworm.jsptags;

import javax.servlet.http.*;
import javax.servlet.jsp.*;
import javax.servlet.jsp.jstl.core.*;
import org.apache.taglibs.standard.lang.support.*;

/**
 * This class is a custom action for testing if a String value
 * contains a substring.
 * If it does, the body is evaluated. If a var attribute is provided,
 * the result is also saved as a Boolean variable in the specified
 * scope, or in the page if no scope is specified.
 *

 */
public class IfContainsTag extends ConditionalTagSupport {
    private String valueEL;
    private String substringEL;

    public void setValue(String value) {
	valueEL = value;
    }

    public void setSubstring(String substring) {
	substringEL = substring;
    }

    public boolean condition() throws JspTagException {
	/*
         * Evaluate the EL expressions
	 */
	String value = null;
	String substring = null;
	try {
	    value = (String)
		ExpressionEvaluatorManager.evaluate("value", valueEL,
		    String.class, this, pageContext);
	    substring = (String)
		ExpressionEvaluatorManager.evaluate("substring", substringEL,
		    String.class, this, pageContext);
	}
	catch (JspException e) {
	    throw new JspTagException(e.getMessage());
	}
	if (value == null || substring == null) {
	    throw new JspTagException("ifContains: one of the attributes is null");
	}
	return value.indexOf(substring) != -1;
    }
}
