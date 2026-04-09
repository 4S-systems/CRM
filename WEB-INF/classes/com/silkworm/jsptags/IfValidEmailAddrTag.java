package com.silkworm.jsptags;

import javax.servlet.jsp.*;
import javax.servlet.jsp.jstl.core.*;
import org.apache.taglibs.standard.lang.support.*;
import com.silkworm.util.*;

/**
 * This class is a custom action for testing if a string value
 * is in the format of a valid SMTP email address.
 * If it is, the body is evaluated. If a var attribute is provided,
 * the result is also saved as a Boolean variable in the specified
 * scope, or in the page if no scope is specified.
 *
 *
 */
public class IfValidEmailAddrTag extends ConditionalTagSupport {
    private String valueEL;

    public void setValue(String value) {
	valueEL = value;
    }

    public boolean condition() throws JspTagException {
	/*
         * Evaluate the EL expression, if any
	 */
	String emailAddr = null;
	try {
	    emailAddr = (String)
		ExpressionEvaluatorManager.evaluate("value", valueEL,
		    String.class, this, pageContext);
	}
	catch (JspException e) {
	    throw new JspTagException(e.getMessage());
	}
	return StringFormat.isValidEmailAddr(emailAddr);
    }
}
