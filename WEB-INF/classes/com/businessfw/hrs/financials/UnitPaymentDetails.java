package com.businessfw.hrs.financials;

import java.util.Date;

public class UnitPaymentDetails {

    private String planDetailsID;
    private Double paymentAmount = 0.0;
    private Double paidAmount = 0.0;
    private String statusName;
    private Date paymentDate;
    private String paymentType;

    public String getPlanDetailsID() {
        return planDetailsID;
    }

    public void setPlanDetailsID(String planDetailsID) {
        this.planDetailsID = planDetailsID;
    }

    public Double getPaymentAmount() {
        return paymentAmount;
    }

    public void setPaymentAmount(Double paymentAmount) {
        this.paymentAmount = paymentAmount;
    }

    public Double getPaidAmount() {
        return paidAmount;
    }

    public void setPaidAmount(Double paidAmount) {
        this.paidAmount = paidAmount;
    }

    public String getStatusName() {
        return statusName;
    }

    public void setStatusName(String statusName) {
        this.statusName = statusName;
    }

    public Date getPaymentDate() {
        return paymentDate;
    }

    public void setPaymentDate(Date paymentDate) {
        this.paymentDate = paymentDate;
    }

    public String getPaymentType() {
        return paymentType;
    }

    public void setPaymentType(String paymentType) {
        this.paymentType = paymentType;
    }

}
