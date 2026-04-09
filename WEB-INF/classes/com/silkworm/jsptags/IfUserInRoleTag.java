package com.silkworm.jsptags;

import javax.servlet.http.*;
import javax.servlet.jsp.*;
import javax.servlet.jsp.jstl.core.*;
import org.apache.taglibs.standard.lang.support.*;

/**
 * This class is a custom action for testing if the current (authenticated)
 * user belongs to the specified security role.
 * If he/she is, the body is evaluated. If a var attribute is provided,
 * the result is also saved as a Boolean variable in the specified
 * scope, or in the page if no scope is specified.
 *

 */
public class IfUserInRoleTag extends ConditionalTagSupport {
    private String valueEL;

    public void setValue(String value) {
        valueEL = value;
    }

    public boolean condition() throws JspTagException {
        /*
         * Evaluate the EL expression, if any
         */
        String role = null;
        try {
            role = (String)
                ExpressionEvaluatorManager.evaluate("value", valueEL,
                    String.class, this, pageContext);
        }
        catch (JspException e) {
            throw new JspTagException(e.getMessage());
        }
        HttpServletRequest request =
            (HttpServletRequest) pageContext.getRequest();
        return request.isUserInRole(role);
    }
}
