package com.silkworm.jsptags;

import javax.servlet.http.*;
import javax.servlet.jsp.tagext.*;

/**
 * This class is a custom action for invalidating a session,
 * causing all session scope variables to be removed and the
 * session to be terminated (marked as invalid).

 */
public class InvalidateSessionTag extends TagSupport {
    /**
     * Invalidates the session.
     */
    public int doEndTag() {
	HttpSession session = pageContext.getSession();
	if (session != null) {
	    session.invalidate();
	}
        return EVAL_PAGE;
    }
}
