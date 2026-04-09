package com.crm.common;

import static com.maintenance.common.Tools.getFileSeparator;
import com.maintenance.common.WboCollectionDataSource;

import com.silkworm.common.MetaDataMgr;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import javax.sql.DataSource;

import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.JasperRunManager;

public class PDFTools {

    static MetaDataMgr dataMgr = MetaDataMgr.getInstance();

    public static void generatePdfReport(String reportName, Map parameters, ServletContext context, HttpServletResponse response) {
        try {
            String dbURL = dataMgr.getDataBaseURL();
            String dbUserName = dataMgr.getDataBaseUserName();
            String dbPassword = dataMgr.getDataBasePassword();

            Connection conn = DriverManager.getConnection(dbURL, dbUserName, dbPassword);

            MetaDataMgr metaMgr = MetaDataMgr.getInstance();
            String companyName = metaMgr.getCompanyNameForLogo();
            String logoName = "logo";

            if (companyName != null) {
                logoName += "-" + companyName + ".png";
            } else {
                logoName = "logo.png";
            }

            /*String reportFileNameSource = context.getRealPath(getFileSeparator() + "reports" + getFileSeparator() + reportName + ".jrxml");
             String reportFileName = context.getRealPath(getFileSeparator() + "reports" + getFileSeparator() + reportName + ".jasper");
             String subReportDir = context.getRealPath(getFileSeparator() + "reports") + getFileSeparator();
             String logoPath = context.getRealPath(getFileSeparator() + "images" + getFileSeparator() + logoName);*/
            String reportFileNameSource = context.getRealPath("/" + "reports" + getFileSeparator() + reportName + ".jrxml");
            String reportFileName = context.getRealPath("/" + "reports" + getFileSeparator() + reportName + ".jasper");
            String subReportDir = context.getRealPath("/" + "reports") + getFileSeparator();
            String logoPath = context.getRealPath("/" + "images" + getFileSeparator() + logoName);

            parameters.put("SUBREPORT_DIR", subReportDir);
            parameters.put("logo", logoPath);

            // Compile report if needed
            File reportFileSource = new File(reportFileNameSource);
            if (!reportFileSource.exists()) {
                throw new FileNotFoundException(String.valueOf(reportFileSource));
            }

            JasperCompileManager.compileReportToFile(reportFileNameSource, reportFileName);

            byte[] bytes;

            bytes = JasperRunManager.runReportToPdf(reportFileName, parameters, conn);

            response.reset();
            ServletOutputStream servletOutputStream = response.getOutputStream();
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "inline; filename=\"" + reportName.toUpperCase() + ".pdf\"");
            response.setContentLength(bytes.length);
            servletOutputStream.write(bytes, 0, bytes.length);
            servletOutputStream.flush();
            servletOutputStream.close();
        } catch (FileNotFoundException ex) {
            System.out.println(ex.getMessage());
        } catch (IOException ex) {
            System.out.println(ex.getMessage());
        } catch (JRException ex) {
            System.out.println(ex.getMessage());
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        }
    }
    
    public static void generatePdfReportWithStarsImgs(String reportName, Map parameters, ServletContext context, HttpServletResponse response) {
        try {
            String dbURL = dataMgr.getDataBaseURL();
            String dbUserName = dataMgr.getDataBaseUserName();
            String dbPassword = dataMgr.getDataBasePassword();

            Connection conn = DriverManager.getConnection(dbURL, dbUserName, dbPassword);

            MetaDataMgr metaMgr = MetaDataMgr.getInstance();
            String companyName = metaMgr.getCompanyNameForLogo();
            String logoName = "logo";

            if (companyName != null) {
                logoName += "-" + companyName + ".png";
            } else {
                logoName = "logo.png";
            }

            /*String reportFileNameSource = context.getRealPath(getFileSeparator() + "reports" + getFileSeparator() + reportName + ".jrxml");
             String reportFileName = context.getRealPath(getFileSeparator() + "reports" + getFileSeparator() + reportName + ".jasper");
             String subReportDir = context.getRealPath(getFileSeparator() + "reports") + getFileSeparator();
             String logoPath = context.getRealPath(getFileSeparator() + "images" + getFileSeparator() + logoName);*/
            String reportFileNameSource = context.getRealPath("/" + "reports" + getFileSeparator() + reportName + ".jrxml");
            String reportFileName = context.getRealPath("/" + "reports" + getFileSeparator() + reportName + ".jasper");
            String subReportDir = context.getRealPath("/" + "reports") + getFileSeparator();
            String logoPath = context.getRealPath("/" + "images" + getFileSeparator() + logoName);

            parameters.put("SUBREPORT_DIR", subReportDir);
            parameters.put("logo", logoPath);
            parameters.put("oneStar",context.getRealPath("/" + "images" +"/"+"icons"+getFileSeparator() + "star.png"));
            parameters.put("twoStars",context.getRealPath("/" + "images" +"/"+"icons"+getFileSeparator() + "twoStars.png"));
            parameters.put("threeStars",context.getRealPath("/" + "images" +"/"+"icons"+getFileSeparator() + "threeStars.png"));
            parameters.put("redCircle",context.getRealPath("/" + "images" +"/"+"icons"+getFileSeparator() + "circle_red.png"));

            // Compile report if needed
            File reportFileSource = new File(reportFileNameSource);
            if (!reportFileSource.exists()) {
                throw new FileNotFoundException(String.valueOf(reportFileSource));
            }

            JasperCompileManager.compileReportToFile(reportFileNameSource, reportFileName);

            byte[] bytes;

            bytes = JasperRunManager.runReportToPdf(reportFileName, parameters, conn);

            response.reset();
            ServletOutputStream servletOutputStream = response.getOutputStream();
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "inline; filename=\"" + reportName.toUpperCase() + ".pdf\"");
            response.setContentLength(bytes.length);
            servletOutputStream.write(bytes, 0, bytes.length);
            servletOutputStream.flush();
            servletOutputStream.close();
        } catch (FileNotFoundException ex) {
            System.out.println(ex.getMessage());
        } catch (IOException ex) {
            System.out.println(ex.getMessage());
        } catch (JRException ex) {
            System.out.println(ex.getMessage());
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        }
    }

}
