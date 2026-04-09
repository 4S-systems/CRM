/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.silkworm.automation;

/**
 *
 * @author walid
 */
import org.quartz.*;

public class FirstReport implements Job {

    public FirstReport() {
    }

    @Override
    public void execute(JobExecutionContext context) throws JobExecutionException {
        FacelessReports.exportDepartmentListReport();
    }
}
