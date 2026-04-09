package com.silkworm.jsptags;

import javax.servlet.http.*;
import javax.servlet.jsp.*;
import javax.servlet.jsp.tagext.*;
import org.apache.taglibs.standard.lang.support.*;

/**
 * This class is a custom action for setting response header
 * values.
 *

 */
public class SetHeaderTag extends TagSupport {
    private String nameEL;
    private String valueEL;

    /**
     * Sets the name attribute.
     *
     * @param name the parameter name
     */
    public void setName(String name) {
        nameEL = name;
    }

    /**
     * Sets the value attribute from a String.
     *
     * @param value the parameter String value
     */
    public void setValue(String value) {
        valueEL = value;
    }

    /**
     * Sets the header specified by the name property to the value
     * specified by the value property.
     */
    public int doEndTag() throws JspException {
        /*
         * Evaluate the EL expressions
         */
        String name = (String)
            ExpressionEvaluatorManager.evaluate("name", nameEL,
                String.class, this, pageContext);
        String value = (String)
            ExpressionEvaluatorManager.evaluate("value", valueEL,
                String.class, this, pageContext);

        if (value == null || name == null) {
            throw new JspTagException("setHeader: " +
                 "one of the attributes is null");
        }
        HttpServletResponse response =
            (HttpServletResponse) pageContext.getResponse();
        response.setHeader(name, value);

        return EVAL_PAGE;
    }

    public void release() {
        nameEL = null;
        valueEL = null;
    }
}
