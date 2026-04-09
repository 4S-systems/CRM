package com.businessfw.hrs.financials;

import java.math.BigDecimal;

public class Food extends SalaryItem {
    public Food(String empID, BigDecimal basicSalary) {
        super(empID,basicSalary);
    }
    
    @Override
    public BigDecimal calculateSalary() {
        if(persent == true){
            totalSalary = basicSalary.multiply(percentValue).divide(new BigDecimal(100));
        } else {
            totalSalary = salaryItemValue;
        }
        
        return totalSalary;
    }   
}
