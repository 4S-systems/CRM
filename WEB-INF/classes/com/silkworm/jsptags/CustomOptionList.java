package com.silkworm.jsptags;

import java.io.IOException;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.tagext.BodyContent;
import javax.servlet.jsp.tagext.BodyTagSupport;
import javax.servlet.jsp.JspTagException;

public class CustomOptionList extends BodyTagSupport {

    private Integer start;
    private Integer stop;
    private String scrollTo;
    
    public CustomOptionList() { super(); }

    @Override
    public int doStartTag() throws JspException, JspException {
        JspWriter out = pageContext.getOut();

        try {
            for(int index = this.start; index <= this.stop; index++) {
                out.print("<OPTION value=\"");
                out.print(index);
                out.print("\"");
                if(Integer.valueOf(index).equals(Integer.valueOf(this.scrollTo))) {
                    out.print(" SELECTED");
                }

                out.print(">");
                out.print(index);
                out.println("</OPTION>");
            }
        } catch (IOException ioe) {
            throw new JspTagException(ioe.toString());
        }
        return SKIP_BODY;
    }

    @Override
    public int doEndTag() throws JspException, JspException {
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
        // Since the doAfterBody method is guarded, place exception handing code here.
        throw new JspException("error in WBOOptionListTag: " + ex);
    }
    
    @Override
    public int doAfterBody() throws JspException {
        try {
            JspWriter out = getPreviousOut();
            
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

    public boolean theBodyShouldBeEvaluated()  {  return true; }

    public boolean shouldEvaluateRestOfPageAfterEndTag() { return true; }

    public boolean theBodyShouldBeEvaluatedAgain() { return false; }

    public Integer getStart() {
        return start;
    }

    public void setStart(Integer start) {
        this.start = start;
    }

    public Integer getStop() {
        return stop;
    }

    public void setStop(Integer stop) {
        this.stop = stop;
    }

    public String getScrollTo() {
        return scrollTo;
    }

    public void setScrollTo(String scrollTo) {
        this.scrollTo = scrollTo;
    }
}
