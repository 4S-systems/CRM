/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.silkworm.common.bus_admin;

/**
 *
 * @author MSaudi
 */
public final class Users {

    private static final String tester = "1";
    private static final String customer = "2";
    private static final String support = "5";
    private static final String manager = "4";
    private static final String developer = "3";

    public static String getDeveloperID() {
        return developer;
    }

    public static String getManagerID() {
        return manager;
    }

    public static String getTesterID() {
        return tester;
    }

    public static String getSupportID() {
        return support;
    }

    public static String getCustomerID() {
        return customer;
    }
}
