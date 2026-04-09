package com.silkworm.business_objects;

import java.util.*;

public class WebAppUser extends WebBusinessObject {

    /**
     * Creates a new instance of WebAppUser
     */
    private String userId = null;
    private String userName = null;
    private String password = null;
    private String ipaddress = null;
    private String email = null;
    private String isSuperUser = null;
    private String fullName = null;
    private String isManager = null;

    public WebAppUser() {
    }

    public WebAppUser(Hashtable contents) {
        super(contents);

        Date loginTime = null;
        Long longDate = new Long((String) this.getAttribute("loginTime"));
        loginTime = new Date(longDate.longValue());

        this.setAttribute("loginTime", loginTime.toString());

    }

    public String getSessionID() {
        return (String) this.getAttribute("sessionId");
    }

    public void setUserID(Integer id) {
        userId = id.toString();
    }

    public void setIPAdress(String remoteAdress) {
        ipaddress = remoteAdress;
    }

    public String getIPAdress() {
        return ipaddress;
    }

    public void setUserId(int id) {
        userId = new Integer(id).toString();
    }

    public void setUserId(String id) {
        userId = id;
    }

    public String getUserId() {
        return (String) this.getAttribute("userId");
    }

    public void setUserID(Long id) {
        userId = id.toString();
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getUserName() {
        String hashedUserName = (String) this.getAttribute("userName");
        if (null != hashedUserName) {
            return hashedUserName;
        } else {
            return userName;
        }
    }

    public void setEmail(String sEmail) {
        email = sEmail;
    }

    public String getEmail() {
        return (email != null ? email : null);
    }

    public void setPassword(String pWord) {
        password = pWord;
    }

    public String getPassword() {

        String hashedPassword = (String) this.getAttribute("password");

        if (null != hashedPassword) {
            return hashedPassword;
        } else {
            return password;
        }
    }

    public String getIsSuperUser() {
        return isSuperUser;
    }

    public void setIsSuperUser(String isSuperUser) {
        this.isSuperUser = (isSuperUser == null) ? "0" : isSuperUser;
    }

    @Override
    public boolean equals(Object obj) {
        WebAppUser compareTo = (WebAppUser) obj;
        String original = (String) this.getAttribute("userId");
        String copy = (String) compareTo.getAttribute("userId");

        String originalIPAddress = (String) this.getAttribute("remoteAddress");
        String copyIPAddress = (String) compareTo.getAttribute("remoteAddress");


        if ((original.equals(copy)) || (originalIPAddress.equals(copyIPAddress))) {
            return true;
        } else {
            return false;
        }
    }

    @Override
    public int hashCode() {
        int hash = 3;
        hash = 97 * hash + (this.userId != null ? this.userId.hashCode() : 0);
        return hash;
    }

    /**
     * @return the fullName
     */
    public String getFullName() {
        return fullName;
    }

    /**
     * @param fullName the fullName to set
     */
    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    /**
     * @return the isManager
     */
    public String getIsManager() {
        return isManager;
    }

    /**
     * @param isManager the isManager to set
     */
    public void setIsManager(String isManager) {
        this.isManager = isManager;
    }
}
