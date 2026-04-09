package com.silkworm.jsptags;

import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import javax.servlet.jsp.tagext.*;
import org.apache.taglibs.standard.lang.support.*;

/**
 * This class is a custom action for sending a forwarding request,
 * with possible parameter values URL encoded.
 * It's a replacement for the standard <code>&lt;jsp:forward&gt;</code>
 * standard action, with the exception that it supports an EL expression
 * as the <code>page</code> attribute value, and nested
 * <code>&lt;ora:param&gt;</code> actions for additional parameters.
 *

 */
public class ForwardTag extends TagSupport implements ParamParent {
    private String pageEL;
    private ArrayList params;

    /**
     * Sets the page attribute.
     *
     * @param page the page URL to redirect to
     */
    public void setPage(String page) {
        pageEL = page;
    }

    /**
     * Adds a parameter name and value. This method is called by param
     * tags in the action body.
     *
     * @param name the parameter name
     * @param value the URL encoded parameter value
     */
    public void addParam(String name, String value) {
        if (params == null) {
            params = new ArrayList();
        }
        Param param = new Param(name, value);
        params.add(param);
    }

    /**
     * Override the default implementation so that possible
     * param actions in the body are processed.
     */
    public int doStartTag() {
        // Reset per-invocation state set by nested elements
        params = null;
        return EVAL_BODY_INCLUDE;
    }

    /**
     * Appends possible URL encoded parameters to the main URI
     * and forwards to the target page. Returns SKIP_PAGE
     * to abort the processing of the rest of the page.
     */
    public int doEndTag() throws JspException {
        /*
         * Evaluate the EL expressions, if any
         */
        String page = (String)
            ExpressionEvaluatorManager.evaluate("page", pageEL,
                String.class, this, pageContext);

        StringBuffer uri = new StringBuffer(page);
        if (params != null && params.size() > 0) {
            if (page.indexOf('?') == -1) {
                uri.append('?');
            }
            else {
                uri.append('&');
            }
            boolean isFirst = true;
            Iterator i = params.iterator();
            while (i.hasNext()) {
                Param p = (Param) i.next();
                if (!isFirst) {
                    uri.append('&');
                }
                uri.append(p.getName()).append('=').append(p.getValue());
                isFirst = false;
            }
        }
        ServletRequest request = pageContext.getRequest();
        RequestDispatcher rd = request.getRequestDispatcher(uri.toString());
        if (uri == null) {
            throw new JspTagException("Resource not found: " + uri);
        }
        try {
            rd.forward(request, pageContext.getResponse());
        }
        catch (IOException e) {
            throw new JspException("Error forwarding: " + e.getMessage(),
                e);
        }
        catch (ServletException e) {
            throw new JspException("Error forwarding: " + e.getMessage(),
                e);
        }
        return SKIP_PAGE;
    }

    /**
     * Releases all instance variables.
     */
    public void release() {
        pageEL = null;
        params = null;
        super.release();
    }

    /**
     * This is a helper class that holds the name and value of a
     * parameter.
     */
    class Param {
        private String name;
        private String value;

        public Param(String name, String value) {
            this.name = name;
            this.value = value;
        }

        public String getName() {
            return name;
        }

        public String getValue() {
            return value;
        }
    }
}
