package com.businessfw.hrs.financials;

import java.math.BigDecimal;

public class BasicSalary extends SalaryItem {

    public BasicSalary(String empID, BigDecimal basicSalary) {
        super(empID, basicSalary);
    }

    @Override
    public BigDecimal calculateSalary() {
        totalSalary = basicSalary;
        return totalSalary;
    }
}
