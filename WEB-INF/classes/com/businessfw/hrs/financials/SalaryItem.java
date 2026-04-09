package com.businessfw.hrs.financials;

import java.math.BigDecimal;

public class SalaryItem implements SalaryCalculate {

    protected String empID;

    protected boolean isDebtItem = true;

    protected BigDecimal basicSalary = new BigDecimal("0.0");
    protected BigDecimal totalSalary = new BigDecimal("0.0");
    protected BigDecimal percentValue = new BigDecimal("0.0");
    protected boolean persent = false;
    protected BigDecimal salaryItemValue = new BigDecimal("0.0");

    public SalaryItem(String empID, BigDecimal basicSalary) {
        this.empID = empID;
        this.basicSalary = basicSalary;

    }

    @Override
    public BigDecimal calculateSalary() {
        // we do the calculations according to rules here        
        return totalSalary;
    }

    public void setIsPersent(boolean perset) {
        this.persent = perset;
    }
    
    public boolean getIsPersent(){
        return this.persent;
    }

    public String getCreditType() {
        if (true == isDebtItem) {
            return "debit";
        } else {
            return "credit";
        }
    }

    public boolean isIsCreditItem() {
        return !isDebtItem;
    }

    public void setIsDebtItem(boolean isDebtItem) {
        this.isDebtItem = isDebtItem;
    }

    public boolean isIsDebtItem() {
        return isDebtItem;
    }

    public void setPersentValue(BigDecimal percentValue) {
        this.percentValue = percentValue;
    }

    public BigDecimal getPersentValue() {
        return this.percentValue;
    }

    public BigDecimal getTotalSlaryItem() {
        return totalSalary;
    }
    
    public void setSalaryItemValue(BigDecimal salaryItemValue){
        this.salaryItemValue = salaryItemValue;
    }
    
    public BigDecimal getSalaryItemValue(){
        return salaryItemValue;
    }
}
