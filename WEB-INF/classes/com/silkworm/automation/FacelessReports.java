/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.silkworm.automation;

/**
 *
 * @author Administrator
 */

import com.externalReports.servlets.PDFReportServlet;
import com.maintenance.common.Tools;
import com.maintenance.db_access.AllMaintenanceInfoMgr;
import com.maintenance.db_access.IssueByComplaintMgr;
import com.maintenance.db_access.MainCategoryTypeMgr;
import com.maintenance.db_access.UserProjectsMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.persistence.relational.RDBGateWay;
import com.tracker.db_access.ProjectMgr;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;

public abstract class FacelessReports extends RDBGateWay {

    static AllMaintenanceInfoMgr allMaintenanceInfoMgr = AllMaintenanceInfoMgr.getInstance();
    static MainCategoryTypeMgr mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();
    static UserProjectsMgr userProjectsMgr = UserProjectsMgr.getInstance();
    static ProjectMgr projectMgr = ProjectMgr.getInstance();
    
    /**
     * Required Arrangements: place the following files under the specified directories:
     * 1- mainTypesAVGCostReport.jrxml, path: [USER_HOME]/reports
     * 2- small_lehaa_Logo.jpg, path: [USER_HOME]/images
     */
    public static void exportTotalCostReport() {

        Vector data = new Vector();
        WebBusinessObject wbo = new WebBusinessObject();
        Map reportParams = new HashMap();

        reportParams.put("unitNamesStr", "\u0643\u0644 \u0627\u0644\u0623\u0646\u0648\u0627\u0639 \u0627\u0644\u0631\u0626\u064A\u0633\u064A\u0629");
        reportParams.put("siteStrArr", "\u0643\u0644 \u0627\u0644\u0645\u0648\u0627\u0642\u0639");
        reportParams.put("bDate", "2011/01/01");
        reportParams.put("eDate", "2011/06/30");
        reportParams.put("type", "\u0627\u0644\u0646\u0648\u0639");

        wbo.setAttribute("beginDate", "2011/01/01");
        wbo.setAttribute("endDate", "2011/06/30");
        wbo.setAttribute("reportType", "mainTypeRadio");
        wbo.setAttribute("site", userProjectsMgr.getAllUserProjectIds());
        wbo.setAttribute("mainType", mainCategoryTypeMgr.getAllMainTypeIds());

        try {
            
            data = allMaintenanceInfoMgr.getCostingReports(wbo);
            Tools.exportPdfReport("mainTypesAVGCostReport", reportParams, data);

        } catch (SQLException ex) {
            Logger.getLogger(PDFReportServlet.class.getName()).log(Level.SEVERE, null, ex);
        }

    }
    
    public static void exportDepartmentListReport() {

        ArrayList data = null;
        WebBusinessObject wbo = new WebBusinessObject();
        Map reportParams = new HashMap();        

        data = projectMgr.getSubProjectsByCode("cmp");
        Tools.exportPdfReport("DepartmentList", reportParams, data);
    }
}
