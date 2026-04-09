package com.silkworm.jsptags;

import javax.servlet.http.*;
import javax.servlet.jsp.*;
import javax.servlet.jsp.tagext.*;

/**
 * This class is a custom action for setting response headers
 * that prevent the page from being cached by a browser or
 * proxy server.
 *

 */
public class NoCacheTag extends TagSupport {
    /**
     * Sets "no cache" response headers
     */
    public int doEndTag() throws JspException {
        HttpServletResponse response =
            (HttpServletResponse) pageContext.getResponse();
        response.addHeader("Pragma", "No-Cache");
        response.setHeader("Cache-Control", "No-Cache");
        response.setDateHeader("Expires", 0);
        return EVAL_PAGE;
    }
}
