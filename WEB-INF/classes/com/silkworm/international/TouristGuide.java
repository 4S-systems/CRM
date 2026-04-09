/*
 * TouristGuide.java
 *
 * Created on May 24, 2004, 10:20 AM
 */

package com.silkworm.international;

/**
 *
 * @author  walid
 */
import java.util.ResourceBundle;
import java.util.Locale;
import java.io.Serializable;

import com.silkworm.common.MetaDataMgr;

public class TouristGuide extends Object implements Serializable{
    
    private Locale locale = null;
    private ResourceBundle bundle = null;
    private String bundlePath = null;
    
    private MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    
    /** Creates new Babel */
    public TouristGuide(String bPath) {
        bundlePath = bPath;
    
        //locale = new Locale(metaMgr.getMyCountry(),metaMgr.getMyLocale());
          locale = new Locale("US","en");
        //locale = Locale.CANADA_FRENCH;
      // locale = locale = new Locale("AR","eg");
        bundle = ResourceBundle.getBundle(bundlePath, locale);
        
        
    }
    
    public void setLocale(String str) {
        String langString = str.substring(0,2);
        if(langString.equals("en")) locale = new Locale("US", "en");
        if(langString.equals("fr")) locale = new Locale("FR", "fr");
        if(langString.equals("sv")) locale = new Locale("SV", "sv");
        bundle = ResourceBundle.getBundle("/com/docviewer/international/DocTitle", locale);
    }
    
    public void setBundlePath(String path) {
        bundlePath = path;
        
    }
    
    
    public void setFrance() {
        locale = Locale.FRANCE;
        bundle = ResourceBundle.getBundle(bundlePath, locale);
        
    }
    
    
    public String getLocale() {
        return locale.toString();
    }
    
    public String getTitle() {
        return bundle.getString("title");
    }
    
    public String getMessage() {
        return bundle.getString("message");
    }
    
    public String getMessage(String s) {
        return bundle.getString(s);
    }
}
