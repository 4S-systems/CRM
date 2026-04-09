package com.customization.common;

public class CustomizeJOMgr extends CustomizeMgr {
    
    public static CustomizeJOMgr getInstance() {
        if(customizeJOMgr == null) {
            customizeJOMgr = new CustomizeJOMgr();
        }
        return customizeJOMgr;
    }

    private CustomizeJOMgr() {
        super("classes" + FILE_SEPARATOR + "com" + FILE_SEPARATOR + "customization" + FILE_SEPARATOR + "xml" + FILE_SEPARATOR + "customization_issue.xml");
    }

    private static CustomizeJOMgr customizeJOMgr = null;
    public static final String SHIFT_ELEMENT = "Shift";
    public static final String TRADE_ELEMENT = "Trade";
}
