package com.silkworm.jsptags;

import java.io.IOException;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.tagext.BodyContent;
import javax.servlet.jsp.tagext.BodyTagSupport;
import javax.servlet.jsp.JspTagException;

import java.util.*;

import com.silkworm.business_objects.*;

public class Options extends BodyTagSupport {

    private ArrayList listAsArrayList;
    private Vector listAsVector;

    private String displayAttribute;
    private String valueAttribute;
    private String scrollTo;
    
    public Options() { super(); }

    public void otherDoStartTagOperations()  { }
    
    public boolean theBodyShouldBeEvaluated()  { return true; }

    public void otherDoEndTagOperations()  { }

    public boolean shouldEvaluateRestOfPageAfterEndTag()  { return true; }

    @Override
    public int doStartTag() throws JspException, JspException {
        otherDoStartTagOperations();
        
        JspWriter out = pageContext.getOut();
        
        try {
            Iterator wboListIterator;
            if(listAsArrayList != null) {
                wboListIterator = listAsArrayList.iterator();
            } else {
                wboListIterator = listAsVector.iterator();
            }
            
            while (wboListIterator.hasNext()) {
                WebBusinessObject wbo = (WebBusinessObject) wboListIterator.next();
                out.print("<OPTION value=\"");
                out.print( (String) wbo.getAttribute(valueAttribute));
                out.print("\"");
                if(wbo.getAttribute(valueAttribute).toString().equals(this.scrollTo))
                    out.print(" SELECTED");
                out.print(">");
                out.print((String) wbo.getAttribute(displayAttribute));
                out.println("</OPTION>");
            }
        } catch (IOException ioe) {
            throw new JspTagException(ioe.toString());
        }

        return SKIP_BODY;
    }

    @Override
    public int doEndTag() throws JspException, JspException {
        otherDoEndTagOperations();
        
        if (shouldEvaluateRestOfPageAfterEndTag()) {
            return EVAL_PAGE;
        } else {
            return SKIP_PAGE;
        }
    }

    public void writeTagBodyContent(JspWriter out, BodyContent bodyContent) throws IOException {
        bodyContent.writeOut(out);
        bodyContent.clearBody();
    }

    public void handleBodyContentException(Exception ex) throws JspException {
        throw new JspException("error in WBOOptionListTag: " + ex);
    }

    @Override
    public int doAfterBody() throws JspException {
        try {
            JspWriter out = getPreviousOut();
            bodyContent = getBodyContent();
            
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

    public boolean theBodyShouldBeEvaluatedAgain() { return false; }

    public ArrayList getListAsArrayList() {
        return listAsArrayList;
    }

    public void setListAsArrayList(ArrayList listAsArrayList) {
        this.listAsArrayList = listAsArrayList;
    }

    public Vector getListAsVector() {
        return listAsVector;
    }

    public void setListAsVector(Vector listAsVector) {
        this.listAsVector = listAsVector;
    }

    public String getDisplayAttribute() {
        return displayAttribute;
    }

    public void setDisplayAttribute(String displayAttribute) {
        this.displayAttribute = displayAttribute;
    }

    public String getValueAttribute() {
        return valueAttribute;
    }

    public void setValueAttribute(String valueAttribute) {
        this.valueAttribute = valueAttribute;
    }

    public String getScrollTo() {
        return scrollTo;
    }

    public void setScrollTo(String scrollTo) {
        this.scrollTo = scrollTo;
    }

}
