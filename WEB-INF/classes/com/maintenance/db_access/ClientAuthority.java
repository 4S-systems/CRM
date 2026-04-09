package com.maintenance.db_access;

import java.io.Serializable;
import java.util.Date;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlType;

@XmlType(propOrder = {"id", "clientIpAddress", "clientName", "isAuthorized", "isPaid", "isLocked", "usersCount", "creationTime"})
@XmlRootElement(name = "clientAuthority")

public class ClientAuthority implements Serializable {

    private static final long serialVersionUID = 1L;
    private String id;
    private String clientIpAddress;
    private String clientName;
    private Boolean isAuthorized;
    private Boolean isPaid;
    private Boolean isLocked;
    private Short usersCount;
    private Date creationTime;

    public ClientAuthority() {
    }

    public ClientAuthority(String id) {
        this.id = id;
    }

    public ClientAuthority(String id, String clientIpAddress, String clientName) {
        this.id = id;
        this.clientIpAddress = clientIpAddress;
        this.clientName = clientName;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getClientIpAddress() {
        return clientIpAddress;
    }

    public void setClientIpAddress(String clientIpAddress) {
        this.clientIpAddress = clientIpAddress;
    }

    public String getClientName() {
        return clientName;
    }

    public void setClientName(String clientName) {
        this.clientName = clientName;
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

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (id != null ? id.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        if (!(object instanceof ClientAuthority)) {
            return false;
        }
        ClientAuthority other = (ClientAuthority) object;
        return !((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id)));
    }

    @Override
    public String toString() {
        return "com._4s_.model.ClientAuthority[ id=" + id + " ]";
    }

}
