package com.silkworm.jsptags;

import com.silkworm.common.TimeServices;
import com.silkworm.util.DateAndTimeConstants;
import java.util.ArrayList;
import java.util.Calendar;
import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.jsp.JspFactory;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.SkipPageException;

public class DropdownDate {
    
    private static java.util.List _jspx_dependants;
    
    /** Creates a new instance of DropdownDate */
    public DropdownDate() {
    }
    
    public String getDateTagAsString(String fieldName, String context, Calendar c, int no)
    //throws java.io.IOException, ServletException
    {
        //Calendar c = Calendar.getInstance();
        int iMonth = c.get(Calendar.MONTH);
        String realMonth = new Integer(iMonth + 1).toString();
        if(realMonth.length() == 1){
            realMonth = "0" + realMonth;
        }
        int iYear = c.get(Calendar.YEAR);
        int iDay = c.get(Calendar.DATE);
        String realDay = new Integer(iDay).toString();
        if(realDay.length() == 1){
            realDay = "0" + realDay;
        }
        ArrayList arrMonth = DateAndTimeConstants.getMonthsList();
        String forTag =    "<script src='js/formElements.js' type='text/javascript'></script>\r\n";
        forTag = forTag + ("<link href=\"css/css_master.css\" rel=\"stylesheet\" type=\"text/css\" />\r\n");
        forTag = forTag + ("<script type=\"text/javascript\">\r\n");
        forTag = forTag + ("    var sjwuic_ScrollCookie = new sjwuic_ScrollCookie('/rave', '/rave/rave'); \r\n");
        forTag = forTag + ("</script>\r\n");
        forTag = forTag + ("<script src=\"js/calendar.js\" type=\"text/javascript\"></script>\r\n");
        forTag = forTag + ("<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" class=\"CalRootTbl\" id=\"calendar1\" style=\"position: absolute\" title=\"\">\r\n");
        forTag = forTag + ("    <tr>\r\n");
        forTag = forTag + ("        <td valign=\"top\">\r\n");
        forTag = forTag + ("            <span class=\"\">\r\n");
        forTag = forTag + ("                <input readonly class=\"TxtFld\" id=\"" + fieldName + "\" name=\"" + fieldName + "\" size=\"20\" type=\"text\" value=\"" + realMonth + "/" + realDay + "/" + iYear + "\" />\r\n");
//        forTag = forTag + ("                <div class=\"HlpFldTxt\" id=\"form" + no + ":calendar1_pattern\">mm/dd/yyyy</div>\r\n");
        forTag = forTag + ("            </span>\r\n");
        forTag = forTag + ("        </td>\r\n");
        forTag = forTag + ("        <td valign=\"top\">\r\n");
        forTag = forTag + ("            <div style=\"position: absolute;\">\r\n");
        forTag = forTag + ("                <span class=\"CalPopFldImg\">\r\n");
        forTag = forTag + ("                    <span>\r\n");
        forTag = forTag + ("                    <a href=\"#\" id=\"form" + no + ":calendar1:_datePickerLink\" onclick=\"javascript: form" + no + "_calendar1_jsObject.toggle(); return false;return hyperlink_submit(this, 'form" + no + "', null);\" title=\"Calendar (Opens a Pop-up Window)\"><img align=\"middle\" alt=\"Calendar (Opens a Pop-up Window)\" border=\"0\" id=\"_datePickerLink_image\" src=\"" + context + "/images/showcalendar.gif\" /></a></span>\r\n");
        forTag = forTag + ("                </span>\r\n");
        forTag = forTag + ("                <div class=\"CalPopShdDiv\" id=\"form" + no + ":calendar1:_datePicker\">\r\n");
        forTag = forTag + ("                    <div class=\"CalPopShd2Div\">\r\n");
        forTag = forTag + ("                        <div class=\"CalPopDiv\">\r\n");
        forTag = forTag + ("                            <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\r\n");
        forTag = forTag + ("                                <tr><td valign=\"top\">\r\n");
        forTag = forTag + ("                                    <div class=\"DatSelDiv\">\r\n");
        forTag = forTag + ("                                        <table border=\"0\" cellpadding=\"0\" cellspacing=\"0\">\r\n");
        forTag = forTag + ("                                            <tr>\r\n");
        forTag = forTag + ("                                                <td align=\"left\">\r\n");
        forTag = forTag + ("                                                    <a href=\"#\" id=\"form" + no + ":calendar1:_datePicker:previousMonthLink\" onclick=\"javascript: form" + no + "_calendar1_jsObject.decreaseMonth(); return false;return hyperlink_submit(this, 'form" + no + "', null);\"><img alt=\"Go Back One Month\" border=\"0\" id=\"previousMonthLink_image\" src=\"" + context + "/images/backward.gif\" /></a>\r\n");
        forTag = forTag + ("                                                </td>\r\n");
        forTag = forTag + ("                                                <td align=\"left\">\r\n");
        forTag = forTag + ("                                                    <select class=\"MnuJmp\" id=\"monthMenu" + no + "\" name=\"monthMenu" + no + "\" onchange=\"form" + no + "_calendar1_jsObject.redrawCalendar(false); return false;;jumpDropDown_changed('monthMenu" + no + "');  return false;\" size=\"1\" title=\"List of Months (Display Month You Select) \">\r\n");
        for(int i = 0; i < arrMonth.size();i++){
            forTag = forTag + ("                                                        <option class=\"MnuJmpOpt\" ");
            if(iMonth == i){
                forTag = forTag + ("selected=\"selected\" ");
            }
            forTag = forTag + ("value=\"" + (i + 1) + "\">" + arrMonth.get(i).toString() + "</option>\r\n");
        }
        forTag = forTag + ("                                                    </select>\r\n");
        forTag = forTag + ("                                                    <input disabled id=\"form" + no + ":calendar1:_datePicker:monthMenu" + no + "_submitter\" name=\"form" + no + ":calendar1:_datePicker:monthMenu" + no + "_submitter\" type=\"hidden\" value=\"false\" />\r\n");
        forTag = forTag + ("                                                <td align=\"left\">\r\n");
        forTag = forTag + ("                                                    <a href=\"#\" id=\"form" + no + ":calendar1:_datePicker:nextMonthLink\" onclick=\"javascript: form" + no + "_calendar1_jsObject.increaseMonth(); return false;return hyperlink_submit(this, 'form" + no + "', null);\"><img alt=\"Go Forward One Month\" border=\"0\" id=\"nextMonthLink_image\" src=\"" + context + "/images/forward.gif\" /></a>\r\n");
        forTag = forTag + ("                                                </td>\r\n");
        forTag = forTag + ("                                                <td width=\"8\"></td>\r\n");
        forTag = forTag + ("                                                <td>\r\n");
        forTag = forTag + ("                                                    <select class=\"MnuJmp\" id=\"yearMenu" + no + "\" name=\"yearMenu" + no + "\" onchange=\"form" + no + "_calendar1_jsObject.redrawCalendar(false); return false;;jumpDropDown_changed('yearMenu" + no + "');  return false;\" size=\"1\" title=\"List of Years (Display Year You Select) \">\r\n");
        for(int i = iYear - 50; i < iYear + 50; i++){
            forTag = forTag + ("                                                        <option class=\"MnuJmpOptSel\" ");
            if(iYear == i){
                forTag = forTag + ("selected=\"selected\" ");
            }
            forTag = forTag + ("value=\"" + i + "\">" + i + "</option>\r\n");
        }
        forTag = forTag + ("                                                    </select>\r\n");
        forTag = forTag + ("                                                    <input disabled id=\"form" + no + ":calendar1:_datePicker:yearMenu" + no + "_submitter\" name=\"form" + no + ":calendar1:_datePicker:yearMenu" + no + "_submitter\" type=\"hidden\" value=\"false\" />\r\n");
        forTag = forTag + ("                                                </td>\r\n");
        forTag = forTag + ("                                            </tr>\r\n");
        forTag = forTag + ("                                        </table>\r\n");
        forTag = forTag + ("                                    </div>\r\n");
        forTag = forTag + ("                                    <div class=\"SkpMedGry1\">\r\n");
        forTag = forTag + ("                                        <a href=\"#form" + no + ":calendar1:_datePicker_skipSection\">\r\n");
        forTag = forTag + ("                                        </a>\r\n");
        forTag = forTag + ("                                    </div><div class=\"DatCalDiv\">\r\n");
        forTag = forTag + ("                                        <table border=\"0\" cellpadding=\"0\" cellspacing=\"1\" class=\"DatCalTbl\" width=\"100%\">\r\n");
        forTag = forTag + ("                                            <tr>\r\n");
        forTag = forTag + ("                                                <th align=\"center\" scope=\"col\">\r\n");
        forTag = forTag + ("                                                    <span class=\"DatDayHdrTxt\">\r\n");
        forTag = forTag + ("                                                        S\r\n");
        forTag = forTag + ("                                                    </span>\r\n");
        forTag = forTag + ("                                                </th>\r\n");
        forTag = forTag + ("                                                <th align=\"center\" scope=\"col\">\r\n");
        forTag = forTag + ("                                                    <span class=\"DatDayHdrTxt\">\r\n");
        forTag = forTag + ("                                                        M\r\n");
        forTag = forTag + ("                                                    </span>\r\n");
        forTag = forTag + ("                                                </th>\r\n");
        forTag = forTag + ("                                                <th align=\"center\" scope=\"col\">\r\n");
        forTag = forTag + ("                                                    <span class=\"DatDayHdrTxt\">\r\n");
        forTag = forTag + ("                                                        T\r\n");
        forTag = forTag + ("                                                    </span>\r\n");
        forTag = forTag + ("                                                </th>\r\n");
        forTag = forTag + ("                                                <th align=\"center\" scope=\"col\">\r\n");
        forTag = forTag + ("                                                    <span class=\"DatDayHdrTxt\">\r\n");
        forTag = forTag + ("                                                        W\r\n");
        forTag = forTag + ("                                                    </span>\r\n");
        forTag = forTag + ("                                                </th>\r\n");
        forTag = forTag + ("                                                <th align=\"center\" scope=\"col\">\r\n");
        forTag = forTag + ("                                                    <span class=\"DatDayHdrTxt\">\r\n");
        forTag = forTag + ("                                                        T\r\n");
        forTag = forTag + ("                                                    </span>\r\n");
        forTag = forTag + ("                                                </th>\r\n");
        forTag = forTag + ("                                                <th align=\"center\" scope=\"col\">\r\n");
        forTag = forTag + ("                                                    <span class=\"DatDayHdrTxt\">\r\n");
        forTag = forTag + ("                                                        F\r\n");
        forTag = forTag + ("                                                    </span>\r\n");
        forTag = forTag + ("                                                </th>\r\n");
        forTag = forTag + ("                                                <th align=\"center\" scope=\"col\">\r\n");
        forTag = forTag + ("                                                    <span class=\"DatDayHdrTxt\">\r\n");
        forTag = forTag + ("                                                        S\r\n");
        forTag = forTag + ("                                                    </span>\r\n");
        forTag = forTag + ("                                                </th>\r\n");
        forTag = forTag + ("                                            </tr>\r\n");
        forTag = forTag + ("                                            <tr id=\"form" + no + ":calendar1:_datePicker:row0\">\r\n");
        forTag = forTag + ("                                                <td align=\"center\">\r\n");
        forTag = forTag + ("                                                    <a class=\"DatOthLnk\" href=\"#\" id=\"form" + no + ":calendar1:_datePicker:dateLink0\" onclick=\"form" + no + "_calendar1_jsObject.dayClicked(this); return false;\" title=\"06/25/2006\">25</a>\r\n");
        forTag = forTag + ("                                                </td>\r\n");
        forTag = forTag + ("                                                <td align=\"center\">\r\n");
        forTag = forTag + ("                                                    <a class=\"DatOthLnk\" href=\"#\" id=\"form" + no + ":calendar1:_datePicker:dateLink1\" onclick=\"form" + no + "_calendar1_jsObject.dayClicked(this); return false;\" title=\"06/26/2006\">26</a>\r\n");
        forTag = forTag + ("                                                </td>\r\n");
        forTag = forTag + ("                                                <td align=\"center\">\r\n");
        forTag = forTag + ("                                                    <a class=\"DatOthLnk\" href=\"#\" id=\"form" + no + ":calendar1:_datePicker:dateLink2\" onclick=\"form" + no + "_calendar1_jsObject.dayClicked(this); return false;\" title=\"06/27/2006\">27</a>\r\n");
        forTag = forTag + ("                                                </td>\r\n");
        forTag = forTag + ("                                                <td align=\"center\">\r\n");
        forTag = forTag + ("                                                    <a class=\"DatOthLnk\" href=\"#\" id=\"form" + no + ":calendar1:_datePicker:dateLink3\" onclick=\"form" + no + "_calendar1_jsObject.dayClicked(this); return false;\" title=\"06/28/2006\">28</a>\r\n");
        forTag = forTag + ("                                                </td>\r\n");
        forTag = forTag + ("                                                <td align=\"center\">\r\n");
        forTag = forTag + ("                                                    <a class=\"DatOthLnk\" href=\"#\" id=\"form" + no + ":calendar1:_datePicker:dateLink4\" onclick=\"form" + no + "_calendar1_jsObject.dayClicked(this); return false;\" title=\"06/29/2006\">29</a>\r\n");
        forTag = forTag + ("                                                </td>\r\n");
        forTag = forTag + ("                                                <td align=\"center\">\r\n");
        forTag = forTag + ("                                                    <a class=\"DatOthLnk\" href=\"#\" id=\"form" + no + ":calendar1:_datePicker:dateLink5\" onclick=\"form" + no + "_calendar1_jsObject.dayClicked(this); return false;\" title=\"06/30/2006\">30</a>\r\n");
        forTag = forTag + ("                                                </td>\r\n");
        forTag = forTag + ("                                                <td align=\"center\">\r\n");
        forTag = forTag + ("                                                    <a class=\"DatLnk\" href=\"#\" id=\"form" + no + ":calendar1:_datePicker:dateLink6\" onclick=\"form" + no + "_calendar1_jsObject.dayClicked(this); return false;\" title=\"07/01/2006\">1</a>\r\n");
        forTag = forTag + ("                                                </td>\r\n");
        forTag = forTag + ("                                            </tr>\r\n");
        forTag = forTag + ("                                            <tr id=\"form" + no + ":calendar1:_datePicker:row1\">\r\n");
        forTag = forTag + ("                                                <td align=\"center\">\r\n");
        forTag = forTag + ("                                                    <a class=\"DatLnk\" href=\"#\" id=\"form" + no + ":calendar1:_datePicker:dateLink7\" onclick=\"form" + no + "_calendar1_jsObject.dayClicked(this); return false;\" title=\"07/02/2006\">2</a>\r\n");
        forTag = forTag + ("                                                </td>\r\n");
        forTag = forTag + ("                                                <td align=\"center\">\r\n");
        forTag = forTag + ("                                                    <a class=\"DatLnk\" href=\"#\" id=\"form" + no + ":calendar1:_datePicker:dateLink8\" onclick=\"form" + no + "_calendar1_jsObject.dayClicked(this); return false;\" title=\"07/03/2006\">3</a>\r\n");
        forTag = forTag + ("                                                </td>\r\n");
        forTag = forTag + ("                                                <td align=\"center\">\r\n");
        forTag = forTag + ("                                                    <a class=\"DatLnk\" href=\"#\" id=\"form" + no + ":calendar1:_datePicker:dateLink9\" onclick=\"form" + no + "_calendar1_jsObject.dayClicked(this); return false;\" title=\"07/04/2006\">4</a>\r\n");
        forTag = forTag + ("                                                </td>\r\n");
        forTag = forTag + ("                                                <td align=\"center\">\r\n");
        forTag = forTag + ("                                                    <a class=\"DatLnk\" href=\"#\" id=\"form" + no + ":calendar1:_datePicker:dateLink10\" onclick=\"form" + no + "_calendar1_jsObject.dayClicked(this); return false;\" title=\"07/05/2006\">5</a>\r\n");
        forTag = forTag + ("                                                </td>\r\n");
        forTag = forTag + ("                                                <td align=\"center\">\r\n");
        forTag = forTag + ("                                                    <a class=\"DatLnk\" href=\"#\" id=\"form" + no + ":calendar1:_datePicker:dateLink11\" onclick=\"form" + no + "_calendar1_jsObject.dayClicked(this); return false;\" title=\"07/06/2006\">6</a>\r\n");
        forTag = forTag + ("                                                </td>\r\n");
        forTag = forTag + ("                                                <td align=\"center\">\r\n");
        forTag = forTag + ("                                                    <a class=\"DatLnk\" href=\"#\" id=\"form" + no + ":calendar1:_datePicker:dateLink12\" onclick=\"form" + no + "_calendar1_jsObject.dayClicked(this); return false;\" title=\"07/07/2006\">7</a>\r\n");
        forTag = forTag + ("                                                </td>\r\n");
        forTag = forTag + ("                                                <td align=\"center\">\r\n");
        forTag = forTag + ("                                                    <a class=\"DatLnk\" href=\"#\" id=\"form" + no + ":calendar1:_datePicker:dateLink13\" onclick=\"form" + no + "_calendar1_jsObject.dayClicked(this); return false;\" title=\"07/08/2006\">8</a>\r\n");
        forTag = forTag + ("                                                </td>\r\n");
        forTag = forTag + ("                                            </tr>\r\n");
        forTag = forTag + ("                                            <tr id=\"form" + no + ":calendar1:_datePicker:row2\">\r\n");
        forTag = forTag + ("                                                <td align=\"center\">\r\n");
        forTag = forTag + ("                                                    <a class=\"DatCurLnk\" href=\"#\" id=\"form" + no + ":calendar1:_datePicker:dateLink14\" onclick=\"form" + no + "_calendar1_jsObject.dayClicked(this); return false;\" title=\"07/09/2006\">9</a>\r\n");
        forTag = forTag + ("                                                </td>\r\n");
        forTag = forTag + ("                                                <td align=\"center\">\r\n");
        forTag = forTag + ("                                                    <a class=\"DatLnk\" href=\"#\" id=\"form" + no + ":calendar1:_datePicker:dateLink15\" onclick=\"form" + no + "_calendar1_jsObject.dayClicked(this); return false;\" title=\"07/10/2006\">10</a>\r\n");
        forTag = forTag + ("                                                </td>\r\n");
        forTag = forTag + ("                                                <td align=\"center\">\r\n");
        forTag = forTag + ("                                                    <a class=\"DatLnk\" href=\"#\" id=\"form" + no + ":calendar1:_datePicker:dateLink16\" onclick=\"form" + no + "_calendar1_jsObject.dayClicked(this); return false;\" title=\"07/11/2006\">11</a>\r\n");
        forTag = forTag + ("                                                </td>\r\n");
        forTag = forTag + ("                                                <td align=\"center\">\r\n");
        forTag = forTag + ("                                                    <a class=\"DatLnk\" href=\"#\" id=\"form" + no + ":calendar1:_datePicker:dateLink17\" onclick=\"form" + no + "_calendar1_jsObject.dayClicked(this); return false;\" title=\"07/12/2006\">12</a>\r\n");
        forTag = forTag + ("                                                </td>\r\n");
        forTag = forTag + ("                                                <td align=\"center\">\r\n");
        forTag = forTag + ("                                                    <a class=\"DatLnk\" href=\"#\" id=\"form" + no + ":calendar1:_datePicker:dateLink18\" onclick=\"form" + no + "_calendar1_jsObject.dayClicked(this); return false;\" title=\"07/13/2006\">13</a>\r\n");
        forTag = forTag + ("                                                </td>\r\n");
        forTag = forTag + ("                                                <td align=\"center\">\r\n");
        forTag = forTag + ("                                                    <a class=\"DatLnk\" href=\"#\" id=\"form" + no + ":calendar1:_datePicker:dateLink19\" onclick=\"form" + no + "_calendar1_jsObject.dayClicked(this); return false;\" title=\"07/14/2006\">14</a>\r\n");
        forTag = forTag + ("                                                </td>\r\n");
        forTag = forTag + ("                                                <td align=\"center\">\r\n");
        forTag = forTag + ("                                                    <a class=\"DatLnk\" href=\"#\" id=\"form" + no + ":calendar1:_datePicker:dateLink20\" onclick=\"form" + no + "_calendar1_jsObject.dayClicked(this); return false;\" title=\"07/15/2006\">15</a>\r\n");
        forTag = forTag + ("                                                </td>\r\n");
        forTag = forTag + ("                                            </tr>\r\n");
        forTag = forTag + ("                                            <tr id=\"form" + no + ":calendar1:_datePicker:row3\">\r\n");
        forTag = forTag + ("                                                <td align=\"center\">\r\n");
        forTag = forTag + ("                                                    <a class=\"DatLnk\" href=\"#\" id=\"form" + no + ":calendar1:_datePicker:dateLink21\" onclick=\"form" + no + "_calendar1_jsObject.dayClicked(this); return false;\" title=\"07/16/2006\">16</a>\r\n");
        forTag = forTag + ("                                                </td>\r\n");
        forTag = forTag + ("                                                <td align=\"center\">\r\n");
        forTag = forTag + ("                                                    <a class=\"DatLnk\" href=\"#\" id=\"form" + no + ":calendar1:_datePicker:dateLink22\" onclick=\"form" + no + "_calendar1_jsObject.dayClicked(this); return false;\" title=\"07/17/2006\">17</a>\r\n");
        forTag = forTag + ("                                                </td>\r\n");
        forTag = forTag + ("                                                <td align=\"center\">\r\n");
        forTag = forTag + ("                                                    <a class=\"DatLnk\" href=\"#\" id=\"form" + no + ":calendar1:_datePicker:dateLink23\" onclick=\"form" + no + "_calendar1_jsObject.dayClicked(this); return false;\" title=\"07/18/2006\">18</a>\r\n");
        forTag = forTag + ("                                                </td>\r\n");
        forTag = forTag + ("                                                <td align=\"center\">\r\n");
        forTag = forTag + ("                                                    <a class=\"DatLnk\" href=\"#\" id=\"form" + no + ":calendar1:_datePicker:dateLink24\" onclick=\"form" + no + "_calendar1_jsObject.dayClicked(this); return false;\" title=\"07/19/2006\">19</a>\r\n");
        forTag = forTag + ("                                                </td>\r\n");
        forTag = forTag + ("                                                <td align=\"center\">\r\n");
        forTag = forTag + ("                                                    <a class=\"DatLnk\" href=\"#\" id=\"form" + no + ":calendar1:_datePicker:dateLink25\" onclick=\"form" + no + "_calendar1_jsObject.dayClicked(this); return false;\" title=\"07/20/2006\">20</a>\r\n");
        forTag = forTag + ("                                                </td>\r\n");
        forTag = forTag + ("                                                <td align=\"center\">\r\n");
        forTag = forTag + ("                                                    <a class=\"DatLnk\" href=\"#\" id=\"form" + no + ":calendar1:_datePicker:dateLink26\" onclick=\"form" + no + "_calendar1_jsObject.dayClicked(this); return false;\" title=\"07/21/2006\">21</a>\r\n");
        forTag = forTag + ("                                                </td>\r\n");
        forTag = forTag + ("                                                <td align=\"center\">\r\n");
        forTag = forTag + ("                                                    <a class=\"DatLnk\" href=\"#\" id=\"form" + no + ":calendar1:_datePicker:dateLink27\" onclick=\"form" + no + "_calendar1_jsObject.dayClicked(this); return false;\" title=\"07/22/2006\">22</a>\r\n");
        forTag = forTag + ("                                                </td>\r\n");
        forTag = forTag + ("                                            </tr>\r\n");
        forTag = forTag + ("                                            <tr id=\"form" + no + ":calendar1:_datePicker:row4\">\r\n");
        forTag = forTag + ("                                                <td align=\"center\">\r\n");
        forTag = forTag + ("                                                    <a class=\"DatLnk\" href=\"#\" id=\"form" + no + ":calendar1:_datePicker:dateLink28\" onclick=\"form" + no + "_calendar1_jsObject.dayClicked(this); return false;\" title=\"07/23/2006\">23</a>\r\n");
        forTag = forTag + ("                                                </td>\r\n");
        forTag = forTag + ("                                                <td align=\"center\">\r\n");
        forTag = forTag + ("                                                    <a class=\"DatLnk\" href=\"#\" id=\"form" + no + ":calendar1:_datePicker:dateLink29\" onclick=\"form" + no + "_calendar1_jsObject.dayClicked(this); return false;\" title=\"07/24/2006\">24</a>\r\n");
        forTag = forTag + ("                                                </td>\r\n");
        forTag = forTag + ("                                                <td align=\"center\">\r\n");
        forTag = forTag + ("                                                    <a class=\"DatLnk\" href=\"#\" id=\"form" + no + ":calendar1:_datePicker:dateLink30\" onclick=\"form" + no + "_calendar1_jsObject.dayClicked(this); return false;\" title=\"07/25/2006\">25</a>\r\n");
        forTag = forTag + ("                                                </td>\r\n");
        forTag = forTag + ("                                                <td align=\"center\">\r\n");
        forTag = forTag + ("                                                    <a class=\"DatLnk\" href=\"#\" id=\"form" + no + ":calendar1:_datePicker:dateLink31\" onclick=\"form" + no + "_calendar1_jsObject.dayClicked(this); return false;\" title=\"07/26/2006\">26</a>\r\n");
        forTag = forTag + ("                                                </td>\r\n");
        forTag = forTag + ("                                                <td align=\"center\">\r\n");
        forTag = forTag + ("                                                    <a class=\"DatLnk\" href=\"#\" id=\"form" + no + ":calendar1:_datePicker:dateLink32\" onclick=\"form" + no + "_calendar1_jsObject.dayClicked(this); return false;\" title=\"07/27/2006\">27</a>\r\n");
        forTag = forTag + ("                                                </td>\r\n");
        forTag = forTag + ("                                                <td align=\"center\">\r\n");
        forTag = forTag + ("                                                    <a class=\"DatLnk\" href=\"#\" id=\"form" + no + ":calendar1:_datePicker:dateLink33\" onclick=\"form" + no + "_calendar1_jsObject.dayClicked(this); return false;\" title=\"07/28/2006\">28</a>\r\n");
        forTag = forTag + ("                                                </td>\r\n");
        forTag = forTag + ("                                                <td align=\"center\">\r\n");
        forTag = forTag + ("                                                    <a class=\"DatLnk\" href=\"#\" id=\"form" + no + ":calendar1:_datePicker:dateLink34\" onclick=\"form" + no + "_calendar1_jsObject.dayClicked(this); return false;\" title=\"07/29/2006\">29</a>\r\n");
        forTag = forTag + ("                                                </td>\r\n");
        forTag = forTag + ("                                            </tr>\r\n");
        forTag = forTag + ("                                            <tr id=\"form" + no + ":calendar1:_datePicker:row5\">\r\n");
        forTag = forTag + ("                                                <td align=\"center\">\r\n");
        forTag = forTag + ("                                                    <a class=\"DatLnk\" href=\"#\" id=\"form" + no + ":calendar1:_datePicker:dateLink35\" onclick=\"form" + no + "_calendar1_jsObject.dayClicked(this); return false;\" title=\"07/30/2006\">30</a>\r\n");
        forTag = forTag + ("                                                </td>\r\n");
        forTag = forTag + ("                                                <td align=\"center\">\r\n");
        forTag = forTag + ("                                                    <a class=\"DatLnk\" href=\"#\" id=\"form" + no + ":calendar1:_datePicker:dateLink36\" onclick=\"form" + no + "_calendar1_jsObject.dayClicked(this); return false;\" title=\"07/31/2006\">31</a>\r\n");
        forTag = forTag + ("                                                </td>\r\n");
        forTag = forTag + ("                                                <td align=\"center\">\r\n");
        forTag = forTag + ("                                                    <a class=\"DatOthLnk\" href=\"#\" id=\"form" + no + ":calendar1:_datePicker:dateLink37\" onclick=\"form" + no + "_calendar1_jsObject.dayClicked(this); return false;\" title=\"08/01/2006\">1</a>\r\n");
        forTag = forTag + ("                                                </td>\r\n");
        forTag = forTag + ("                                                <td align=\"center\">\r\n");
        forTag = forTag + ("                                                    <a class=\"DatOthLnk\" href=\"#\" id=\"form" + no + ":calendar1:_datePicker:dateLink38\" onclick=\"form" + no + "_calendar1_jsObject.dayClicked(this); return false;\" title=\"08/02/2006\">2</a>\r\n");
        forTag = forTag + ("                                                </td>\r\n");
        forTag = forTag + ("                                                <td align=\"center\">\r\n");
        forTag = forTag + ("                                                    <a class=\"DatOthLnk\" href=\"#\" id=\"form" + no + ":calendar1:_datePicker:dateLink39\" onclick=\"form" + no + "_calendar1_jsObject.dayClicked(this); return false;\" title=\"08/03/2006\">3</a>\r\n");
        forTag = forTag + ("                                                </td>\r\n");
        forTag = forTag + ("                                                <td align=\"center\">\r\n");
        forTag = forTag + ("                                                    <a class=\"DatOthLnk\" href=\"#\" id=\"form" + no + ":calendar1:_datePicker:dateLink40\" onclick=\"form" + no + "_calendar1_jsObject.dayClicked(this); return false;\" title=\"08/04/2006\">4</a>\r\n");
        forTag = forTag + ("                                                </td>\r\n");
        forTag = forTag + ("                                                <td align=\"center\">\r\n");
        forTag = forTag + ("                                                    <a class=\"DatOthLnk\" href=\"#\" id=\"form" + no + ":calendar1:_datePicker:dateLink41\" onclick=\"form" + no + "_calendar1_jsObject.dayClicked(this); return false;\" title=\"08/05/2006\">5</a>\r\n");
        forTag = forTag + ("                                                </td>\r\n");
        forTag = forTag + ("                                            </tr>\r\n");
        forTag = forTag + ("                                            <tr>\r\n");
        forTag = forTag + ("                                                <td class=\"CalPopFtr\" colspan=\"7\">\r\n");
        forTag = forTag + ("                                                    <div class=\"CalPopFtrDiv\">\r\n");
        forTag = forTag + ("                                                        <span class=\"CurDayTxt\">\r\n");
        forTag = forTag + ("                                                            " + arrMonth.get(iMonth).toString() + " " + iDay + ", " + iYear + "\r\n");
        forTag = forTag + ("                                                        </span>\r\n");
        forTag = forTag + ("                                                        <div>\r\n");
        forTag = forTag + ("                                                            <a name=\"form" + no + ":calendar1:_datePicker_skipSection\"></a>\r\n");
        forTag = forTag + ("                                                        </div><a class=\"CalPopClsLnk\" href=\"#\" onclick=\"form" + no + "_calendar1_jsObject.toggle(); return false;\">close</a>\r\n");
        forTag = forTag + ("                                                    </div>\r\n");
        forTag = forTag + ("                                                </td>\r\n");
        forTag = forTag + ("                                            </tr>\r\n");
        forTag = forTag + ("                                        </table>\r\n");
        forTag = forTag + ("                                    </div>\r\n");
        forTag = forTag + ("                                </td>\r\n");
        forTag = forTag + ("                                </tr>\r\n");
        forTag = forTag + ("                            </table>\r\n");
        forTag = forTag + ("                        </div>\r\n");
        forTag = forTag + ("                    </div>\r\n");
        forTag = forTag + ("                </div>\r\n");
        forTag = forTag + ("                <script type=\"text/javascript\">\r\n");
        forTag = forTag + ("                    var form" + no + "_calendar1_jsObject = new ui_Calendar(0, '" + fieldName + "', 'form" + no + ":calendar1_pattern', 'form" + no + ":calendar1:_datePickerLink', 'form" + no + ":calendar1:_datePicker', 'monthMenu" + no + "', 'yearMenu" + no + "', 'form" + no + ":calendar1:_datePicker:row5', 'jar:" + context + "/WEB-INF/lib/defaulttheme.jar!/com/sun/rave/web/ui/defaulttheme/images/calendar/showcalendar.gif', 'jar:" + context + "/defaulttheme.jar!/com/sun/rave/web/ui/defaulttheme/images/calendar/showcalendar_flip.gif', 'MM/dd/yyyy', 'DatLnk', 'DatOthLnk', 'DatBldLnk', 'DatOthBldLnk', 'DatCurLnk', 'hidden');\r\n");
        forTag = forTag + ("                </script>\r\n");
        forTag = forTag + ("            </div>\r\n");
        forTag = forTag + ("        </td>\r\n");
        forTag = forTag + ("    </tr>\r\n");
        forTag = forTag + ("</table>");
        return forTag;
    }
    
    public java.sql.Timestamp getDate(String sDate){
        String[] timeStamp = new String[6];
        
        String[] arrDate = sDate.split("/");
        int iMonth ;
        if(arrDate.length>1){
            iMonth = new Integer(arrDate[0]).intValue() - 1;            
            timeStamp[0] = arrDate[2];
            timeStamp[1] = new Integer(iMonth).toString();
            timeStamp[2] = arrDate[1];
        }else{
            arrDate=sDate.split("-");
            iMonth = new Integer(arrDate[1]).intValue() - 1;
            timeStamp[0]=arrDate[0];
            
            timeStamp[1]= new Integer(iMonth).toString();
            timeStamp[2]=arrDate[2];
        }
        timeStamp[3] = new String("00");
        timeStamp[4] = new String("00");
        timeStamp[5] = new String("00");
        
        return TimeServices.toTimestamp(timeStamp);
    }
    
}
