package com.silkworm.jsptags;

import java.net.*;
import javax.servlet.jsp.*;
import javax.servlet.jsp.tagext.*;
import org.apache.taglibs.standard.lang.support.*;

/**
 * This class is a custom action intended to be used in the body of
 * custom actions implementing the ParamTag interface. It adds the
 * specified parameter name and value to it's parent's list of parameters.

 */
public class ParamTag extends TagSupport {
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
     * Adds the parameter name and the URL encoded value to the
     * parent's parameter list.
     */
    public int doEndTag() throws JspException {
	/*
         * Evaluate the EL expressions, if any
	 */
	String name = (String)
	    ExpressionEvaluatorManager.evaluate("name", nameEL,
		String.class, this, pageContext);
	String value = (String)
	    ExpressionEvaluatorManager.evaluate("value", valueEL,
		String.class, this, pageContext);

        Tag parent = findAncestorWithClass(this, ParamParent.class);
        if (parent == null) {
            throw new JspException("The param action is not " +
                "enclosed by a supported action type");
        }
        ParamParent paramParent = (ParamParent) parent;
        paramParent.addParam(URLEncoder.encode(name),
	    URLEncoder.encode(value));
        return EVAL_PAGE;
    }

    /**
     * Releases all instance variables.
     */
    public void release() {
        nameEL = null;
        valueEL = null;
        super.release();
    }
}
