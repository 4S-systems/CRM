/*
 * OptionList.java
 *
 * Created on October 28, 2003, 3:26 AM
 */

package com.silkworm.jsptags;



import java.io.IOException;
import java.text.Collator;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;
import java.util.Locale;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.JspTagException;
import javax.servlet.jsp.tagext.TagSupport;

public class OptionList extends TagSupport {

    private Locale locale;
    private ArrayList optionList;
    private String scrollTo;

    public OptionList() {
        locale = Locale.getDefault();
        optionList = null;
        scrollTo = null;
    }

    public void setLocale(Locale locale) {
        this.locale = locale;
    }

    public void setOptionList(ArrayList optionList) {
        this.optionList = optionList;
    }
    
    public void setScrollTo(String scrollTo)
    {
     this.scrollTo=scrollTo;   
    }    

    public int doStartTag() throws JspException {
        JspWriter out = pageContext.getOut();

        try {
            Collator collator = Collator.getInstance(locale);
           // Collections.sort(optionList, collator);
            Iterator sortedList = optionList.iterator();
            while (sortedList.hasNext()) {
                String option = (String) sortedList.next();
                out.print("<OPTION value=\"");
                out.print(option);
                out.print("\"");
                if(option.equals(this.scrollTo))
                    out.print(" SELECTED");
                out.print(">");
                out.print(option);
                out.println("</OPTION>");
            }
        }
        catch (IOException ioe) {
            throw new JspTagException(ioe.toString());
        }
        return SKIP_BODY;
    }

    public void release() {
        super.release();
        locale = Locale.getDefault();
        optionList = null;
    }
}


