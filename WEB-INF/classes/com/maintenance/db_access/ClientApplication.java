package com.maintenance.db_access;

import java.io.Serializable;
import java.util.Date;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlType;

@XmlType(propOrder = {"id", "applicationName", "applicationCode", "isAuthorized", "isPaid", "isLocked", "usersCount", "creationTime", "purchaseDate"})
@XmlRootElement(name = "clientApplication")
public class ClientApplication implements Serializable {

    private static final long serialVersionUID = 1L;

    private String id;
    private String applicationName;
    private String applicationCode;
    private Boolean isAuthorized;
    private Boolean isPaid;
    private Boolean isLocked;
    private Short usersCount;
    private Date creationTime;
    private Date purchaseDate;

    public ClientApplication() {
    }

    public ClientApplication(String id) {
        this.id = id;
    }

    public ClientApplication(String id, String applicationName, String applicationCode) {
        this.id = id;
        this.applicationName = applicationName;
        this.applicationCode = applicationCode;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getApplicationName() {
        return applicationName;
    }

    public void setApplicationName(String applicationName) {
        this.applicationName = applicationName;
    }

    public String getApplicationCode() {
        return applicationCode;
    }

    public void setApplicationCode(String applicationCode) {
        this.applicationCode = applicationCode;
    }

    public Boolean isIsAuthorized() {
        return isAuthorized;
    }

    public void setIsAuthorized(Boolean isAuthorized) {
        this.isAuthorized = isAuthorized;
    }

    public Boolean isIsPaid() {
        return isPaid;
    }

    public void setIsPaid(Boolean isPaid) {
        this.isPaid = isPaid;
    }

    public Boolean isIsLocked() {
        return isLocked;
    }

    public void setIsLocked(Boolean isLocked) {
        this.isLocked = isLocked;
    }

    public Short getUsersCount() {
        return usersCount;
    }

    public void setUsersCount(Short usersCount) {
        this.usersCount = usersCount;
    }

    public Date getCreationTime() {
        return creationTime;
    }

    public void setCreationTime(Date creationTime) {
        this.creationTime = creationTime;
    }

    public Date getPurchaseDate() {
        return purchaseDate;
    }

    public void setPurchaseDate(Date purchaseDate) {
        this.purchaseDate = purchaseDate;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (id != null ? id.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        if (!(object instanceof ClientApplication)) {
            return false;
        }
        ClientApplication other = (ClientApplication) object;
        return !((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id)));
    }

    @Override
    public String toString() {
        return "com._4s_.model.Application[ id=" + id + " ]";
    }

}
