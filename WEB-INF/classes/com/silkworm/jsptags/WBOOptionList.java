/*
 * @(#)WBOOptionList.java
 *
 * Copyright (c) 2006 Ontario Corporation 1534437 previously known as Silkworm Software in the
 *  province of Manitoba - Canada . All Rights Reserved.
 * Redistribution and use in source and binary forms, with or without 
 * modification, are permitted provided that the following conditions are met:
 * 
 * -Redistributions of source code must retain the above copyright notice, this 
 * list of conditions and the following disclaimer.
 *
 * -Redistribution in binary form must reproduct the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 * 
 * Neither the name of Ontario Corporation 1534437 . or the names of contributors may
 * be used to endorse or promote products derived from this software without
 * specific prior written permission.
 * 
 * This software is provided "AS IS," without a warranty of any kind. ALL
 * EXPRESS OR IMPLIED CONDITIONS, REPRESENTATIONS AND WARRANTIES, INCLUDING ANY
 * IMPLIED WARRANTY OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE OR
 * NON-INFRINGEMENT, ARE HEREBY EXCLUDED. SUN AND ITS LICENSORS SHALL NOT BE
 * LIABLE FOR ANY DAMAGES SUFFERED BY LICENSEE AS A RESULT OF USING, MODIFYING
 * OR DISTRIBUTING THE SOFTWARE OR ITS DERIVATIVES. IN NO EVENT WILL SUN OR ITS
 * LICENSORS BE LIABLE FOR ANY LOST REVENUE, PROFIT OR DATA, OR FOR DIRECT,
 * INDIRECT, SPECIAL, CONSEQUENTIAL, INCIDENTAL OR PUNITIVE DAMAGES, HOWEVER
 * CAUSED AND REGARDLESS OF THE THEORY OF LIABILITY, ARISING OUT OF THE USE OF
 * OR INABILITY TO USE SOFTWARE, EVEN IF SUN HAS BEEN ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGES.
 * 
 * You acknowledge that Software is not designed,licensed or intended for use in 
 * the design, construction, operation or maintenance of any nuclear facility.
 */
package com.silkworm.jsptags;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletRequest;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.tagext.BodyContent;
import javax.servlet.jsp.tagext.BodyTag;
import javax.servlet.jsp.tagext.BodyTagSupport;
import javax.servlet.jsp.tagext.IterationTag;
import javax.servlet.jsp.tagext.Tag;
import javax.servlet.jsp.tagext.TagSupport;

import java.util.*;

import com.silkworm.business_objects.*;
import javax.servlet.jsp.JspTagException;

/**
 * Generated tag class.
 */
public class WBOOptionList extends BodyTagSupport {

    /**
     * property declaration for tag attribute: wboList.
     *
     */
    private java.util.List wboList;

    /**
     * property declaration for tag attribute: displayAttribute.
     *
     */
    private java.lang.String displayAttribute;

    /**
     * property declaration for tag attribute: valueAttribute.
     *
     */
    private java.lang.String valueAttribute;

    /**
     * property declaration for tag attribute: scrolTo.
     *
     */
    private java.lang.String scrollTo;

    private java.lang.String scrollToValue;

    public WBOOptionList() {
        super();
    }

    ////////////////////////////////////////////////////////////////
    ///                                                          ///
    ///   User methods.                                          ///
    ///                                                          ///
    ///   Modify these methods to customize your tag handler.    ///
    ///                                                          ///
    ////////////////////////////////////////////////////////////////
    //
    // methods called from doStartTag()
    //
    /**
     *
     * Fill in this method to perform other operations from doStartTag().
     *
     */
    public void otherDoStartTagOperations() {

        //
        // TODO: code that performs other operations in doStartTag
        //       should be placed here.
        //       It will be called after initializing variables,
        //       finding the parent, setting IDREFs, etc, and
        //       before calling theBodyShouldBeEvaluated().
        //
        //       For example, to print something out to the JSP, use the following:
        //
        //   try {
        //       JspWriter out = pageContext.getOut();
        //       out.println("something");
        //   } catch (java.io.IOException ex) {
        //       // do something
        //   }
        //
        //
    }

    /**
     *
     * Fill in this method to determine if the tag body should be evaluated
     * Called from doStartTag().
     *
     */
    public boolean theBodyShouldBeEvaluated() {

        //
        // TODO: code that determines whether the body should be
        //       evaluated should be placed here.
        //       Called from the doStartTag() method.
        //
        return true;

    }

    //
    // methods called from doEndTag()
    //
    /**
     *
     * Fill in this method to perform other operations from doEndTag().
     *
     */
    public void otherDoEndTagOperations() {

        //
        // TODO: code that performs other operations in doEndTag
        //       should be placed here.
        //       It will be called after initializing variables,
        //       finding the parent, setting IDREFs, etc, and
        //       before calling shouldEvaluateRestOfPageAfterEndTag().
        //
    }

    /**
     *
     * Fill in this method to determine if the rest of the JSP page should be
     * generated after this tag is finished. Called from doEndTag().
     *
     */
    public boolean shouldEvaluateRestOfPageAfterEndTag() {

        //
        // TODO: code that determines whether the rest of the page
        //       should be evaluated after the tag is processed
        //       should be placed here.
        //       Called from the doEndTag() method.
        //
        return true;

    }

    ////////////////////////////////////////////////////////////////
    ///                                                          ///
    ///   Tag Handler interface methods.                         ///
    ///                                                          ///
    ///   Do not modify these methods; instead, modify the       ///
    ///   methods that they call.                                ///
    ///                                                          ///
    ////////////////////////////////////////////////////////////////
    /**
     * .
     *
     * This method is called when the JSP engine encounters the start tag, after
     * the attributes are processed. Scripting variables (if any) have their
     * values set here.
     *
     * @return EVAL_BODY_INCLUDE if the JSP engine should evaluate the tag body,
     * otherwise return SKIP_BODY. This method is automatically generated. Do
     * not modify this method. Instead, modify the methods that this method
     * calls.
     *
     *
     */
    public int doStartTag() throws JspException, JspException {
        otherDoStartTagOperations();

        JspWriter out = pageContext.getOut();

        try {

            Iterator wboListIterator = wboList.iterator();
            while (wboListIterator.hasNext()) {
                WebBusinessObject wbo = (WebBusinessObject) wboListIterator.next();
                out.print("<OPTION value=\"");
                out.print((String) wbo.getAttribute(valueAttribute));
                out.print("\"");
                if (wbo.getAttribute(displayAttribute).toString().equals(this.scrollTo) || wbo.getAttribute(valueAttribute).toString().equals(this.scrollToValue)) {
                    out.print(" SELECTED");
                }
                out.print(">");
                out.print((String) wbo.getAttribute(displayAttribute));
                out.println("</OPTION>");
            }
        } catch (IOException ioe) {
            throw new JspTagException(ioe.toString());
        }
        return SKIP_BODY;
    }

    /**
     * .
     *
     *
     * This method is called after the JSP engine finished processing the tag.
     *
     * @return EVAL_PAGE if the JSP engine should continue evaluating the JSP
     * page, otherwise return SKIP_PAGE. This method is automatically generated.
     * Do not modify this method. Instead, modify the methods that this method
     * calls.
     *
     *
     */
    public int doEndTag() throws JspException, JspException {
        otherDoEndTagOperations();

        if (shouldEvaluateRestOfPageAfterEndTag()) {
            return EVAL_PAGE;
        } else {
            return SKIP_PAGE;
        }
    }

    /**
     * .
     * Fill in this method to process the body content of the tag. You only need
     * to do this if the tag's BodyContent property is set to "JSP" or
     * "tagdependent." If the tag's bodyContent is set to "empty," then this
     * method will not be called.
     *
     *
     */
    public void writeTagBodyContent(JspWriter out, BodyContent bodyContent) throws IOException {
        //
        // TODO: insert code to write html before writing the body content.
        //       e.g.  out.println("<B>" + getAttribute1() + "</B>");
        //             out.println("   <BLOCKQUOTE>");

        //
        // write the body content (after processing by the JSP engine) on the output Writer
        //
        bodyContent.writeOut(out);

        //
        // Or else get the body content as a string and process it, e.g.:
        //     String bodyStr = bodyContent.getString();
        //     String result = yourProcessingMethod(bodyStr);
        //     out.println(result);
        //
        // TODO: insert code to write html after writing the body content.
        //       e.g.  out.println("   <BLOCKQUOTE>");
        // clear the body content for the next time through.
        bodyContent.clearBody();
    }

    /**
     * .
     *
     * Handles exception from processing the body content.
     *
     *
     */
    public void handleBodyContentException(Exception ex) throws JspException {
        // Since the doAfterBody method is guarded, place exception handing code here.
        throw new JspException("error in WBOOptionListTag: " + ex);
    }

    /**
     * .
     *
     *
     * This method is called after the JSP engine processes the body content of
     * the tag.
     *
     * @return EVAL_BODY_AGAIN if the JSP engine should evaluate the tag body
     * again, otherwise return SKIP_BODY. This method is automatically
     * generated. Do not modify this method. Instead, modify the methods that
     * this method calls.
     *
     *
     */
    public int doAfterBody() throws JspException {
        try {
            //
            // This code is generated for tags whose bodyContent is "tagdependent"
            //

            JspWriter out = getPreviousOut();
            BodyContent bodyContent = getBodyContent();

            writeTagBodyContent(out, bodyContent);
        } catch (Exception ex) {
            handleBodyContentException(ex);
        }

        if (theBodyShouldBeEvaluatedAgain()) {
            return EVAL_BODY_AGAIN;
        } else {
            return SKIP_BODY;
        }
    }

    /**
     * Fill in this method to determine if the tag body should be evaluated
     * again after evaluating the body. Use this method to create an iterating
     * tag. Called from doAfterBody().
     *
     *
     */
    public boolean theBodyShouldBeEvaluatedAgain() {
        //
        // TODO: code that determines whether the tag body should be
        //       evaluated again after processing the tag
        //       should be placed here.
        //       You can use this method to create iterating tags.
        //       Called from the doAfterBody() method.
        //
        return false;
    }

    public java.util.List getWboList() {
        return wboList;
    }

    public void setWboList(java.util.List value) {
        wboList = value;
    }

    public java.lang.String getDisplayAttribute() {
        return displayAttribute;
    }

    public void setDisplayAttribute(java.lang.String value) {
        displayAttribute = value;
    }

    public java.lang.String getValueAttribute() {
        return valueAttribute;
    }

    public void setValueAttribute(java.lang.String value) {
        valueAttribute = value;
    }

    public void setScrollTo(String scrollTo) {
        this.scrollTo = scrollTo;
    }

    public void setScrollToValue(String scrollToValue) {
        this.scrollToValue = scrollToValue;
    }
}
