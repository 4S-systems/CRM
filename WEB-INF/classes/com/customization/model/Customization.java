package com.customization.model;

public class Customization {
    private String display;
    private String defaultValue;

    public Customization(){
        this("", "");
    }
    public Customization(String display, String defaultValue){
        this.defaultValue = defaultValue;
        this.display = display;
    }

    public boolean display(){
        return (!display.equals("no"));
    }

    public String getDisplay() {
        return display;
    }

    public void setDisplay(String display) {
        this.display = display;
    }

    public String getDefaultValue() {
        return defaultValue;
    }

    public void setDefaultValue(String defaultValue) {
        this.defaultValue = defaultValue;
    }
}
