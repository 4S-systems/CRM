/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.silkworm.common;

/**
 *
 * @author haytham
 */
public enum CustomizationPanelElement {

    CAMPAIGN_ELEMENT("Campaign", "CAMPAIGN"),
    DEFAULT_NEW_CLIENT_DISTRIBUTION_ELEMENT("Default New Client Distribution", "DEFAULT_NEW_CLIENT_DISTRIBUTION"),
    RUN_ON_AUTO_PILOT_ELEMENT("Run On Auto-Pilot Mode", "RUN_ON_AUTO_PILOT"),
    DEFAULT_DESKTOP_ELEMENT("Desktop", "DEFAULT_DESKTOP"),
    DEFAULT_BRANCH_ELEMENT("Branch", "DEFAULT_BRANCH"),
    PRODUCT_ELEMENT("Product", "PRODUCT"),
    CHANEL_DIRECTION_ELEMENT("Communication Chanel Direction", "CHANEL_DIRECTION"),
    CAN_CHANGE_HEAD_BAR_ELEMENT("Can Change", "CAN_CHANGE_HEAD_BAR"),
    DISTRIBUTION_GROUP_ELEMENT("Distribution Group", "DISTRIBUTION_GROUP"),
    PERSONAL_DISTRIBUTION_ELEMENT("Personal Distribution", "PERSONAL_DISTRIBUTION"),
    PERSONAL_DISTRIBUTION_TYPE_ELEMENT("Personal Distribution Type", "PERSONAL_DISTRIBUTION_TYPE");

    private final String title;
    private final String name;

    private CustomizationPanelElement(String title, String name) {
        this.title = title;
        this.name = name;
    }

    public String getTitle() {
        return title;
    }

    public String getName() {
        return name;
    }
    
    public static CustomizationPanelElement parse(String name) {
        CustomizationPanelElement element = null;
        if (CAMPAIGN_ELEMENT.getName().equalsIgnoreCase(name)) {
            element = CAMPAIGN_ELEMENT;
        } else if (DEFAULT_NEW_CLIENT_DISTRIBUTION_ELEMENT.getName().equalsIgnoreCase(name)) {
            element = DEFAULT_NEW_CLIENT_DISTRIBUTION_ELEMENT;
        } else if (DEFAULT_BRANCH_ELEMENT.getName().equalsIgnoreCase(name)) {
            element = DEFAULT_BRANCH_ELEMENT;
        } else if (DEFAULT_DESKTOP_ELEMENT.getName().equalsIgnoreCase(name)) {
            element = DEFAULT_DESKTOP_ELEMENT;
        } else if (PRODUCT_ELEMENT.getName().equalsIgnoreCase(name)) {
            element = PRODUCT_ELEMENT;
        } else if (CHANEL_DIRECTION_ELEMENT.getName().equalsIgnoreCase(name)) {
            element = CHANEL_DIRECTION_ELEMENT;
        } else if (CAN_CHANGE_HEAD_BAR_ELEMENT.getName().equalsIgnoreCase(name)) {
            element = CAN_CHANGE_HEAD_BAR_ELEMENT;
        } else if (RUN_ON_AUTO_PILOT_ELEMENT.getName().equalsIgnoreCase(name)) {
            element = RUN_ON_AUTO_PILOT_ELEMENT;
        } else if (DISTRIBUTION_GROUP_ELEMENT.getName().equalsIgnoreCase(name)) {
            element = DISTRIBUTION_GROUP_ELEMENT;
        } else if (PERSONAL_DISTRIBUTION_ELEMENT.getName().equalsIgnoreCase(name)) {
            element = PERSONAL_DISTRIBUTION_ELEMENT;
        } else if (PERSONAL_DISTRIBUTION_TYPE_ELEMENT.getName().equalsIgnoreCase(name)) {
            element = PERSONAL_DISTRIBUTION_TYPE_ELEMENT;
        }
        return element;
    }

    @Override
    public String toString() {
        return "Title: " + title + ", Name: " + name;
    }
}
