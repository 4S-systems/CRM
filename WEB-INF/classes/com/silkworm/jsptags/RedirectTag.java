package com.silkworm.jsptags;

import java.io.*;
import java.util.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import javax.servlet.jsp.tagext.*;

/**
 * This class is a custom action for sending a redirect request, with possible
 * parameter values URL encoded and the complete URL encoded for URL rewriting
 * (session tracking).
 *
 * @author Hans Bergsten, Gefion software <hans@gefionsoftware.com>
 * @version 1.0
 */
public class RedirectTag extends TagSupport implements ParamParent {

    private String page;
    private Vector params;

    /**
     * Sets the page attribute.
     *
     * @param page the page URL to redirect to
     */
    public void setPage(String page) {
        this.page = page;
    }

    /**
     * Adds a parameter name and value. This method is called by param tags in
     * the action body.
     *
     * @param name the parameter name
     * @param value the URL encoded parameter value
     */
    public void setParam(String name, String value) {
        if (params == null) {
            params = new Vector();
        }
        Param param = new Param(name, value);
        params.addElement(param);
    }

    /**
     * Override the default implementation so that possible param actions in the
     * body are processed.
     */
    public int doStartTag() {
        // Reset per-use state set by nested elements
        params = null;

        return EVAL_BODY_INCLUDE;
    }

    /**
     * Appends possible URL encoded parameters to the main URL, encodes the
     * result for URL rewriting. Clears the out buffer and sets the redirect
     * response headers. Returns SKIP_PAGE to abort the processing of the rest
     * of the page.
     */
    public int doEndTag() throws JspException {
        StringBuffer encodedURL = new StringBuffer(page);
        if (params != null && params.size() > 0) {
            encodedURL.append('?');
            boolean isFirst = true;
            Enumeration e = params.elements();
            while (e.hasMoreElements()) {
                Param p = (Param) e.nextElement();
                if (!isFirst) {
                    encodedURL.append('&');
                }
                encodedURL.append(p.getName()).append('=').append(p.getValue());
                isFirst = false;
            }
        }
        try {
            JspWriter out = pageContext.getOut();
            out.clear();
            HttpServletResponse res = (HttpServletResponse) pageContext.getResponse();
            if (!res.isCommitted()) {
                res.sendRedirect(res.encodeURL(encodedURL.toString()));
            }
        } catch (IOException e) {
        }
        return SKIP_PAGE;
    }

    /**
     * Releases all instance variables.
     */
    public void release() {
        page = null;
        params = null;
        super.release();
    }

    public void addParam(String name, String value) {
    }

    /**
     * This is a helper class that holds the name and value of a parameter.
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
