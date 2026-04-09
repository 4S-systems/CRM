package com.maintenance.common;

import com.SpareParts.db_access.SparePartsMgr;
import com.android.business_objects.LiteWebBusinessObject;
import com.clients.db_access.AppointmentMgr;
import com.clients.db_access.ClientMgr;
import com.contractor.db_access.MaintainableMgr;
import com.maintenance.db_access.DistributionListMgr;
import com.maintenance.db_access.IssueByComplaintAllCaseMgr;
import com.maintenance.db_access.ItemFormListMgr;
import com.maintenance.db_access.ItemsBranchMgr;
import com.maintenance.db_access.ScheduleMgr;
import com.maintenance.db_access.TaskMgr;
import com.maintenance.db_access.UserStoresMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.crm.db_access.CommentsMgr;
import com.crm.servlets.CommentsServlet;
import com.maintenance.db_access.IssueByComplaintMgr;
import com.reportUtil.ReportConfigUtil;
import com.silkworm.common.MetaDataMgr;
import com.silkworm.common.SecurityUser;
import com.silkworm.common.UserMgr;
import com.silkworm.email.EmailUtility;
import com.silkworm.pagination.*;
import com.silkworm.persistence.relational.RDBGateWay;
import com.silkworm.util.DateAndTimeControl;
import com.tracker.db_access.IssueMgr;
import com.tracker.db_access.IssueStatusMgr;
import com.tracker.db_access.ProjectMgr;
import com.workFlowTasks.db_access.WFTaskCommentsMgr;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.Date;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.NumberFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collection;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Vector;

import java.util.logging.Level;
import javax.servlet.ServletContext;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import net.sf.jasperreports.engine.JREmptyDataSource;
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JRExporterParameter;
import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperRunManager;
import net.sf.jasperreports.engine.data.JRBeanCollectionDataSource;
import net.sf.jasperreports.engine.export.JRPdfExporter;
import net.sf.jasperreports.engine.export.ooxml.JRXlsxExporter;
import org.apache.commons.lang.math.NumberUtils;

import org.apache.log4j.Logger;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFCellUtil;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.hssf.util.Region;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.json.simple.JSONValue;

public class Tools {

    protected static Logger logger = Logger.getLogger(RDBGateWay.class);
    private static MaintainableMgr maintainableMgr = MaintainableMgr.getInstance();
    private static SparePartsMgr sparePartsMgr = SparePartsMgr.getInstance();
    private static ItemsBranchMgr itemsBranchMgr = ItemsBranchMgr.getInstance();

    public static String concatenation(String[] list, String separator) {
        StringBuilder concatenation = new StringBuilder();
        int size = list.length;
        int lastIndex = size - 1;
        for (int i = 0; i < size; i++) {
            if (!list[i].isEmpty()) {
                concatenation.append("'").append(list[i]).append("'");
                if (i < lastIndex) {
                    concatenation.append(separator);
                }
            }
        }
        return (!concatenation.toString().isEmpty()) ? concatenation.toString() : "-1";
    }

    public static ArrayList toArrayList(Vector list) {
        ArrayList arrayList = new ArrayList();

        if (list != null && !list.isEmpty()) {
            for (Object object : list) {
                arrayList.add(object);
            }
        }

        return arrayList;
    }

    public static Vector toVector(ArrayList list) {
        Vector vector = new Vector();

        if (list != null && !list.isEmpty()) {
            for (Object object : list) {
                vector.addElement(object);
            }
        }

        return vector;
    }
public static HSSFWorkbook createExcelReport(String sheetName, String headerName, String[] headers, String[] attributes, String[] attributeType, ArrayList data) {
        WebBusinessObject wbo;
        HSSFWorkbook workBook = new HSSFWorkbook();
        HSSFCellStyle cellStyle = workBook.createCellStyle();
        HSSFSheet sheet = workBook.createSheet(sheetName);
        HSSFFont font = workBook.createFont();
        font.setBoldweight(font.BOLDWEIGHT_BOLD);
        cellStyle.setAlignment(cellStyle.ALIGN_CENTER);
        cellStyle.setFont(font);
        cellStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
        cellStyle.setFillForegroundColor(new HSSFColor.GREY_25_PERCENT().getIndex());

        // for Columns Width
        for (int i = 0; i < attributeType.length; i++) {
            if (attributeType[i].equalsIgnoreCase("String")) {
                sheet.setColumnWidth((short) i, (short) 7000);
            } else {
                sheet.setColumnWidth((short) i, (short) 3000);
            }
        }

        // to create the Header
        HSSFRow tableHeaderRow = sheet.createRow((short) 0);
        HSSFCell tableHeaderCellT1 = tableHeaderRow.createCell((short) 1);
        tableHeaderCellT1.setCellStyle(cellStyle);
        tableHeaderCellT1.setCellValue(headerName);
        HSSFCellUtil.setAlignment(tableHeaderCellT1, workBook, HSSFCellStyle.ALIGN_CENTER);
        sheet.addMergedRegion(new Region(0, (short) 1, 0, (short) 5));

        // to create the Report Date
        tableHeaderRow = sheet.createRow((short) 1);
        tableHeaderCellT1 = tableHeaderRow.createCell((short) 1);
        tableHeaderCellT1.setCellStyle(cellStyle);
        tableHeaderCellT1.setCellValue("Report Date :");
        tableHeaderCellT1 = tableHeaderRow.createCell((short) 2);
        tableHeaderCellT1.setCellValue(new java.util.Date().toGMTString());
        HSSFCellUtil.setAlignment(tableHeaderCellT1, workBook, HSSFCellStyle.ALIGN_CENTER);
        sheet.addMergedRegion(new Region(1, (short) 2, 1, (short) 4));

        // to seperate between the Header and Detail[
        HSSFRow emptyRow = sheet.createRow((short) 2);

        // to iterate throw the Headers array
        HSSFRow headerRow = sheet.createRow((short) 3);
        for (int i = 0; i < headers.length; i++) {
            HSSFCell tableHeaderCell1 = headerRow.createCell((short) i);
            tableHeaderCell1.setCellStyle(cellStyle);
            tableHeaderCell1.setCellValue(headers[i]);
        }

        // to iterate throw The attributes array and get Data from The Vector
        for (int i = 0; i < data.size(); i++) {
            wbo = (WebBusinessObject) data.get(i);
            HSSFRow row = sheet.createRow(i + 4);

            for (int j = 0; j < attributes.length; j++) {
                HSSFCell cell = row.createCell((short) j);
                if (attributeType[j].equalsIgnoreCase("Number")) {
                    cell.setCellValue(new Double(wbo.getAttribute(attributes[j]).toString()).doubleValue());
                } else if (attributeType[j].equalsIgnoreCase("Formula")) {
                    cell.setCellFormula(wbo.getAttribute(attributes[j]).toString());
                } else {
                    if (wbo.getAttribute(attributes[j]) != null) {
                        cell.setCellValue(wbo.getAttribute(attributes[j]).toString());
                    } else {
                        cell.setCellValue(i + 1);
                    }
                }
                HSSFCellUtil.setAlignment(cell, workBook, HSSFCellStyle.ALIGN_CENTER);
            }
        }

        return workBook;
    }

public static HSSFWorkbook createExcelReportNested(String sheetName, String[] headerName,String[] headerValueStr, String[] headers, String[] attributes, String[] attributeType, ArrayList data,String[] headers2, String[] attributes2, String[] attributeType2, Map<String, ArrayList<WebBusinessObject>> data2) {
        WebBusinessObject wbo;
        HSSFWorkbook workBook = new HSSFWorkbook();
        HSSFCellStyle cellStyle = workBook.createCellStyle();
        HSSFCellStyle cellStyle2 = workBook.createCellStyle();
        HSSFSheet sheet = workBook.createSheet(sheetName);
        HSSFFont font = workBook.createFont();
        font.setBoldweight(font.BOLDWEIGHT_BOLD);
        HSSFFont font2 = workBook.createFont();
        font2.setColor(IndexedColors.DARK_TEAL.getIndex());
        font2.setBoldweight(font.BOLDWEIGHT_BOLD);
        cellStyle.setAlignment(cellStyle.ALIGN_CENTER);
        cellStyle.setFont(font);
        cellStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
        cellStyle.setFillForegroundColor(new HSSFColor.GREY_25_PERCENT().getIndex());
        //cellStyle2 to style the second header
        
        cellStyle2.setAlignment(cellStyle2.ALIGN_CENTER);
        cellStyle2.setFont(font2);
        cellStyle2.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
        cellStyle2.setFillForegroundColor(new HSSFColor.LIGHT_CORNFLOWER_BLUE().getIndex());

        // for Columns Width
        for (int i = 0; i < attributeType.length; i++) {
            if (attributeType[i].equalsIgnoreCase("String")) {
                sheet.setColumnWidth((short) i, (short) 7000);
            } else {
                sheet.setColumnWidth((short) i, (short) 3000);
            }
        }

        // to create the Header
        int headerNameCount = 0;
        HSSFRow tableHeaderRow = null;
        HSSFCell tableHeaderCellT1 = null;
        for (; headerNameCount < headerName.length && headerName[headerNameCount] != null && !headerName[headerNameCount].isEmpty(); headerNameCount++) {
            tableHeaderRow = sheet.createRow((short) headerNameCount);
            tableHeaderCellT1 = tableHeaderRow.createCell((short) 1);
            tableHeaderCellT1.setCellStyle(cellStyle);
            tableHeaderCellT1.setCellValue(headerName[headerNameCount]);
            if(headerValueStr != null){
                tableHeaderCellT1 = tableHeaderRow.createCell((short) 2);
                tableHeaderCellT1.setCellStyle(cellStyle);
                tableHeaderCellT1.setCellValue(headerValueStr[headerNameCount]);
            }
            HSSFCellUtil.setAlignment(tableHeaderCellT1, workBook, HSSFCellStyle.ALIGN_CENTER);
            sheet.addMergedRegion(new Region(headerNameCount, (short) 2, headerNameCount, (short) 4));
        }

        headerNameCount++;

        // to create the Report Date
        tableHeaderRow = sheet.createRow((short) 1);
        tableHeaderCellT1 = tableHeaderRow.createCell((short) 1);
        tableHeaderCellT1.setCellStyle(cellStyle);
        tableHeaderCellT1.setCellValue("Report Date :");
        tableHeaderCellT1 = tableHeaderRow.createCell((short) 2);
        tableHeaderCellT1.setCellValue(new java.util.Date().toGMTString());
        HSSFCellUtil.setAlignment(tableHeaderCellT1, workBook, HSSFCellStyle.ALIGN_CENTER);
        sheet.addMergedRegion(new Region(1, (short) 2, 1, (short) 4));

        // to seperate between the Header and Detail[
        HSSFRow emptyRow = sheet.createRow((short) 2);

        

        // to iterate throw The attributes array and get Data from The Vector
        for (int k = 0; k < data.size(); k++) {
             // to iterate throw the first Headers array
        HSSFRow headerRow = sheet.createRow((short) 3+(5*k));
        for (int i = 0; i < headers.length; i++) {
            HSSFCell tableHeaderCell1 = headerRow.createCell((short) i);
            tableHeaderCell1.setCellStyle(cellStyle);
            tableHeaderCell1.setCellValue(headers[i]);
        }
        wbo = (WebBusinessObject) data.get(k);
        String clientID=wbo.getAttribute("clientID").toString();
            HSSFRow row1 = sheet.createRow((5*k) + 4);

            for (int j = 0; j < attributes.length; j++) {
                HSSFCell cell = row1.createCell((short) j);
                if (attributeType[j].equalsIgnoreCase("Number")) {
                    cell.setCellValue(new Double(wbo.getAttribute(attributes[j]).toString()).doubleValue());
                } else if (attributeType[j].equalsIgnoreCase("Formula")) {
                    cell.setCellFormula(wbo.getAttribute(attributes[j]).toString());
                } else {
                    if (wbo.getAttribute(attributes[j]) != null) {
                        cell.setCellValue(wbo.getAttribute(attributes[j]).toString());
                    } else {
                        cell.setCellValue(k + 1);
                    }
                }
                HSSFCellUtil.setAlignment(cell, workBook, HSSFCellStyle.ALIGN_CENTER);
            }

       
            
              // to iterate throw the second Headers array
        HSSFRow headerRow2 = sheet.createRow((short) 5+(5*k));
        for (int ii = 0; ii < headers2.length; ii++) {
            HSSFCell tableHeaderCell1 = headerRow2.createCell((short) ii);
            tableHeaderCell1.setCellStyle(cellStyle2);
            tableHeaderCell1.setCellValue(headers2[ii]);
        }
             
             ArrayList<WebBusinessObject> data2wbo=data2.get(clientID);
             for (int i = 0; i < data2wbo.size(); i++) {
            wbo = (WebBusinessObject) data2wbo.get(i);
            HSSFRow row = sheet.createRow((5*k) + 6);

            for (int j = 0; j < attributes2.length; j++) {
                HSSFCell cell = row.createCell((short) j);
                if (attributeType2[j].equalsIgnoreCase("Number")) {
                    cell.setCellValue(new Double(wbo.getAttribute(attributes2[j]).toString()).doubleValue());
                } else if (attributeType2[j].equalsIgnoreCase("Formula")) {
                    cell.setCellFormula(wbo.getAttribute(attributes2[j]).toString());
                } else {
                    if (wbo.getAttribute(attributes2[j]) != null) {
                        cell.setCellValue(wbo.getAttribute(attributes2[j]).toString());
                    } else {
                        cell.setCellValue(k + 1);
                    }
                }
                HSSFCellUtil.setAlignment(cell, workBook, HSSFCellStyle.ALIGN_CENTER);
            }
        }
        }

        return workBook;
    }


    public static String arrayToString(String[] list, String separator) {
        StringBuilder concat = new StringBuilder();
        int size = list.length;
        int lastIndex = size - 1;
        for (int i = 0; i < size; i++) {
            concat.append(list[i]);
            if (i < lastIndex) {
                concat.append(separator);
            }
        }
        return concat.toString();
    }

    public static void createTaskSideMenu(HttpServletRequest request, String taskId) {
        TaskMgr taskMgr = TaskMgr.getInstance();
        WebBusinessObject taskWbo = taskMgr.getOnSingleKey(taskId);
        String mode = request.getSession().getAttribute("currentMode").toString();

        /**
         * *********** Side Menu ****************
         */
        //open Jar File
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        metaMgr.setMetaData("xfile.jar");
        ParseSideMenu parseSideMenu = new ParseSideMenu();
        Vector taskSideMenuVec = parseSideMenu.parseSideMenu(mode, "task_menu.xml", "");
        metaMgr.closeDataSource();

        /* Add ids for links*/
        String link = "";
        Hashtable style = new Hashtable();
        style = (Hashtable) taskSideMenuVec.get(0);
        String title = style.get("title").toString();
        title += " <br> " + taskWbo.getAttribute("title").toString();
        style.remove("title");
        style.put("title", title);

        Vector menuElement = new Vector();
        for (int i = 1; i < taskSideMenuVec.size() - 1; i++) {
            menuElement = new Vector();
            link = "";
            menuElement = (Vector) taskSideMenuVec.get(i);
            link = menuElement.get(1).toString();
            link += taskId;
            menuElement.remove(1);
            menuElement.add(link);
        }

        Hashtable topMenu = new Hashtable();
        Vector tempVec = new Vector();
        topMenu = (Hashtable) request.getSession().getAttribute("topMenu");

        if (topMenu != null && topMenu.size() > 0) {

            /* 1- Get the current Side menu
             * 2- Check Menu Type
             * 3- insert menu object to top menu accordding to it's type
             */
            Vector menuType = new Vector();
            Vector currentSideMenu = (Vector) request.getSession().getAttribute("sideMenuVec");
            Vector linkVec = new Vector();
            if (currentSideMenu != null && currentSideMenu.size() > 0) {
                linkVec = new Vector();

                // the element # 1 in menu is to view the object
                linkVec = (Vector) currentSideMenu.get(1);

                // size-1 becouse the menu type is the last element in vector
                menuType = (Vector) currentSideMenu.get(currentSideMenu.size() - 1);

                if (menuType != null && menuType.size() > 0) {
                    topMenu.put((String) menuType.get(1), linkVec);
                }

            }
            request.getSession().setAttribute("topMenu", topMenu);
        }

        request.getSession().setAttribute("sideMenuVec", taskSideMenuVec);
    }

    public static void ActivateScheduleSideMenu(HttpServletRequest request, String unitId, String scheduleId, String scheduleOn, String mode) {
        ScheduleMgr scheduleMgr = ScheduleMgr.getInstance();
        WebBusinessObject schWbo = scheduleMgr.getOnSingleKey(scheduleId);

        //open Jar File
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        metaMgr.setMetaData("xfile.jar");
        ParseSideMenu parseSideMenu = new ParseSideMenu();
        Vector schMenu = new Vector();

        schMenu = parseSideMenu.parseSideMenu(mode, "schedule_menu.xml", scheduleOn);

        metaMgr.closeDataSource();

        /* Add ids for links*/
        Vector linkVec = new Vector();
        Hashtable style = new Hashtable();
        String link = "";
        String title = "";

        style = (Hashtable) schMenu.get(0);
        title = style.get("title").toString();
        title += "   " + schWbo.getAttribute("maintenanceTitle").toString();
        style.remove("title");
        style.put("title", title);

        // to check if schedule frequencyType is kilometer then not found active schedule
        if (schWbo.getAttribute("frequencyType").equals("5")) {
            schMenu.remove(2);
        }

        for (int i = 1; i < schMenu.size() - 1; i++) {
            linkVec = new Vector();
            link = "";
            linkVec = (Vector) schMenu.get(i);
            link = (String) linkVec.get(1);

            if (scheduleOn.equalsIgnoreCase("c")) {
                link += "&periodicID=" + scheduleId + "&categoryID=" + unitId + "&equipmentCat=" + unitId + "&equipmentCats=" + unitId + "&categoryId=" + unitId + "&scheduleId=" + scheduleId + "&SID=" + scheduleId + "&schId=" + scheduleId + "&scheduleTitle=" + schWbo.getAttribute("maintenanceTitle").toString();
            } else if (scheduleOn.equalsIgnoreCase("mc")) {
                link += "&periodicID=" + scheduleId + "&categoryID=" + unitId + "&mainCatId=" + unitId + "&eqpMainCat=" + unitId + "&scheduleId=" + scheduleId + "&SID=" + scheduleId + "&schId=" + scheduleId + "&scheduleTitle=" + schWbo.getAttribute("maintenanceTitle").toString();
            } else {
                link += "&periodicID=" + scheduleId + "&equipmentID=" + unitId + "&eqpId=" + unitId + "&scheduleId=" + scheduleId + "&SID=" + scheduleId + "&schId=" + scheduleId + "&scheduleTitle=" + schWbo.getAttribute("maintenanceTitle").toString();
            }

            linkVec.remove(1);
            linkVec.add(link);
        }

        Hashtable topMenu = new Hashtable();
        Hashtable tempTopMenu;
        tempTopMenu = (Hashtable) request.getSession().getAttribute("topMenu");

        if (tempTopMenu != null && tempTopMenu.size() > 0) {
            topMenu = tempTopMenu;
        }

        /* 1- Get the current Side menu
         * 2- Check Menu Type
         * 3- insert menu object to top menu accordding to it's type
         */
        Vector menuType = new Vector();
        Vector currentSideMenu = (Vector) request.getSession().getAttribute("sideMenuVec");
        if (currentSideMenu != null && currentSideMenu.size() > 0) {
            linkVec = new Vector();

            // the element # 1 in menu is to view the object
            linkVec = (Vector) currentSideMenu.get(1);

            // size-1 becouse the menu type is the last element in vector
            menuType = (Vector) currentSideMenu.get(currentSideMenu.size() - 1);

            if (menuType != null && menuType.size() > 0) {
                topMenu.put((String) menuType.get(1), linkVec);
            }
        }

        request.getSession().setAttribute("topMenu", topMenu);
        request.getSession().setAttribute("sideMenuVec", schMenu);
    }
    
    public static void createPdfReportUncomntClient(String reportName, Map parameters, Collection dataSource, ServletContext context, HttpServletResponse response, HttpServletRequest request, String logoName) throws IOException {

        MetaDataMgr metaMgr = MetaDataMgr.getInstance();

        /*String reportFileNameSource = context.getRealPath("/" + "reports" + getFileSeparator() + reportName + ".jrxml");
         String reportFileName = context.getRealPath("/" + "reports" + getFileSeparator() + reportName + ".jasper");
         String subReportDir = context.getRealPath("/" + "reports") + getFileSeparator();
         String logoPath = context.getRealPath("/" + "images" + getFileSeparator() + logoName);*/
        String reportFileNameSource = context.getRealPath(getFileSeparator() + "reports" + getFileSeparator() + reportName + ".jrxml");
        String reportFileName = context.getRealPath(getFileSeparator() + "reports" + getFileSeparator() + reportName + ".jasper");
        String subReportDir = context.getRealPath(getFileSeparator() + "reports") + getFileSeparator();
        String logoPath = context.getRealPath(getFileSeparator() + "images" + getFileSeparator() + logoName);

        ArrayList<WebBusinessObject> vec = (ArrayList<WebBusinessObject>) dataSource;

        parameters.put("SUBREPORT_DIR", subReportDir);
        parameters.put("logo", logoPath);

        try {
            // Compile report if needed
            File reportFileSource = new File(reportFileNameSource);
            if (!reportFileSource.exists()) {
                throw new FileNotFoundException(String.valueOf(reportFileSource));
            }

            File reportFile = new File(reportFileName);

            JasperCompileManager.compileReportToFile(reportFileNameSource, reportFileName);

            ServletOutputStream servletOutputStream = response.getOutputStream();
            byte[] bytes;

            bytes = JasperRunManager.runReportToPdf(reportFileName, parameters, new WboCollectionDataSource(dataSource));
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "inline; filename=\"" + reportName.toUpperCase() + ".pdf\"");
            response.setContentLength(bytes.length);
            servletOutputStream.write(bytes, 0, bytes.length);
            servletOutputStream.flush();
            servletOutputStream.close();

        } catch (FileNotFoundException ex) {
            logger.error(ex.getMessage());
        } catch (IOException ex) {
            logger.error(ex.getMessage());
        } catch (JRException ex) {
            logger.error(ex.getMessage());
        }
    }

    public static void createUserSideMenu(String Id, String index, String numberOfUsers, HttpServletRequest request) {
        String dir = "LTR";
        String align = "LEFT";
        UserMgr userMgr = UserMgr.getInstance();
        WebBusinessObject wbo = userMgr.getOnSingleKey(Id);
        String mode = request.getSession().getAttribute("currentMode").toString();
        /**
         * *********** Side Menu ****************
         */
        //open Jar File
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        metaMgr.setMetaData("xfile.jar");
        ParseSideMenu parseSideMenu = new ParseSideMenu();
        Vector userSideMenuVec = parseSideMenu.parseSideMenu(mode, "user_menu.xml", "");
        metaMgr.closeDataSource();

        /* Add ids for links*/
        if ("Ar".equalsIgnoreCase(mode)) {
            dir = "RTL";
            align = "RIGHT";
        }
        String link = "";
        Hashtable style = new Hashtable();
        style = (Hashtable) userSideMenuVec.get(0);
        String title = "<p style='font-weight: bold' align=" + align + " dir=" + dir + ">" + (String) style.get("title");
        title += " " + (String) wbo.getAttribute("userName") + "</p>";
        style.remove("title");
        style.put("title", title);

        Vector menuElement = new Vector();
        for (int i = 1; i < userSideMenuVec.size() - 1; i++) {
            if (i != (userSideMenuVec.size() - 2)) {
                link = "";
                menuElement = (Vector) userSideMenuVec.get(i);
                link = menuElement.get(1).toString();
                link = link.replace("ID", Id).replace("NUM", numberOfUsers).replace("INDX", index);
                menuElement.remove(1);
                menuElement.add(link);
            } else {
                link = "";
                menuElement = (Vector) userSideMenuVec.get(i);
                link = menuElement.get(1).toString();
                menuElement.remove(1);
                menuElement.add(link);

            }
        }

        request.getSession().setAttribute("sideMenuVec", userSideMenuVec);
        request.getSession().setAttribute("currentUserID", Id);
        request.getSession().setAttribute("activeClient", userSideMenuVec);
        request.getSession().setAttribute("normalClient", userSideMenuVec);

    }

    public static void createIssueSideMenu(String attachedEqFlag, WebBusinessObject webIssue, HttpServletRequest request) {
        IssueMgr issueMgr = IssueMgr.getInstance();
        //open Jar File
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        metaMgr.setMetaData("xfile.jar");
        ParseSideMenu parseSideMenu = new ParseSideMenu();
        Vector issueMenu = new Vector();
        String mode = (String) request.getSession().getAttribute("currentMode");
        issueMenu = parseSideMenu.parseSideMenu(mode, "issue_menu.xml", "n");

        metaMgr.closeDataSource();

        /* Add ids for links*/
        Vector linkVec = new Vector();
        String link = "";
        String unitId = (String) webIssue.getAttribute("unitId");

        Hashtable style = new Hashtable();
        style = (Hashtable) issueMenu.get(0);
        String title = style.get("title").toString();
        title += "   " + (String) webIssue.getAttribute("businessID");
        style.remove("title");
        style.put("title", title);

        for (int i = 1; i < issueMenu.size() - 1; i++) {
            linkVec = new Vector();
            link = "";
            linkVec = (Vector) issueMenu.get(i);
            link = (String) linkVec.get(1);

            if (link.equalsIgnoreCase("AssignedIssueServlet?op=assign&state=SCHEDULE&viewOrigin=null&direction=forward&issueId=")) {
                String currentStatus = (String) webIssue.getAttribute("currentStatus");

                if (currentStatus != null) {
                    if (currentStatus.equalsIgnoreCase("Schedule") || currentStatus.equalsIgnoreCase("Rejected")) {
                        link += issueMgr.getIssueID() + "&attachedEqFlag=" + attachedEqFlag + "&equipmentID=" + unitId;
                    } else {
                        issueMenu.remove(i);
                        i--;
                        continue;
                    }
                } else {
                    link += issueMgr.getIssueID() + "&attachedEqFlag=" + attachedEqFlag + "&equipmentID=" + unitId;
                }

            } else {
                link += issueMgr.getIssueID() + "&attachedEqFlag=" + attachedEqFlag + "&equipmentID=" + unitId;
            }
            linkVec.remove(1);
            linkVec.add(link);
        }
        Hashtable topMenu = new Hashtable();
        topMenu = (Hashtable) request.getSession().getAttribute("topMenu");

        if (topMenu != null && topMenu.size() > 0) {
            /* 1- Get the current Side menu
             * 2- Check Menu Type
             * 3- insert menu object to top menu accordding to it's type
             */
            Vector menuType = new Vector();
            Vector currentSideMenu = (Vector) request.getSession().getAttribute("sideMenuVec");
            if (currentSideMenu != null && currentSideMenu.size() > 0) {
                linkVec = new Vector();
                // the element # 1 in menu is to view the object
                linkVec = (Vector) currentSideMenu.get(1);
                // size-1 becouse the menu type is the last element in vector
                menuType = (Vector) currentSideMenu.get(currentSideMenu.size() - 1);
                if (menuType != null && menuType.size() > 0) {
                    topMenu.put((String) menuType.get(1), linkVec);
                }
            }
            request.getSession().setAttribute("topMenu", topMenu);
        }
        request.getSession().setAttribute("sideMenuVec", issueMenu);
    }

    public static void setRequestByStoreInfo(HttpServletRequest request) {
        ItemFormListMgr itemFormListMgr = ItemFormListMgr.getInstance();
        SecurityUser securityUser = (SecurityUser) request.getSession().getAttribute("securityUser");

        UserStoresMgr userStoresMgr = UserStoresMgr.getInstance();
        Vector allStoresVec = new Vector();

        try {
            allStoresVec = userStoresMgr.getOnArbitraryKey(securityUser.getUserId(), "key1");
        } catch (Exception ex) {
            logger.error(ex.getMessage());
        }

        ArrayList allStores = new ArrayList();
        for (Object object : allStoresVec) {
            allStores.add(object);
        }
        for (int i = 0; i < allStores.size(); i++) {
            boolean result = userStoresMgr.updateStores((String) ((WebBusinessObject) allStores.get(i)).getAttribute("storeCode"));
        }

        String selectedStore = "";
        String selectedBranch = "";
        String selectedForm = "";
        Vector itemFormForSelectedStoreVec = new Vector();
        ArrayList itemFormForSelectedStore = new ArrayList();
        if (allStores.size() > 0) {
            selectedStore = (String) ((WebBusinessObject) allStores.get(0)).getAttribute("storeCode");
            selectedBranch = itemFormListMgr.getBranchByStoreCode(selectedStore);
            try {
                itemFormForSelectedStoreVec = itemFormListMgr.getOnArbitraryKey(selectedStore, "key1");
                for (Object object : itemFormForSelectedStoreVec) {
                    itemFormForSelectedStore.add((WebBusinessObject) object);
                }
                if (itemFormForSelectedStore.size() > 0) {
                    selectedForm = (String) ((WebBusinessObject) itemFormForSelectedStore.get(0)).getAttribute("codeForm");
                }
            } catch (Exception ex) {
                logger.error(ex.getMessage());
            }
        }

        request.setAttribute("allStores", allStores);
        request.setAttribute("selectedStore", selectedStore);
        request.setAttribute("selectedBranch", selectedBranch);
        request.setAttribute("itemFormForSelectedStore", itemFormForSelectedStore);
        request.setAttribute("selectedForm", selectedForm);
    }

    public static void setRequestByEquipmentsInfo(HttpServletRequest request, int interval) {
        int indexPage = 0;
        int startIndex, endIndex, numberPages, startPage, endPage;
        long equipmentsNumber;
        Vector equipments;

        try {
            indexPage = Integer.valueOf(request.getParameter("index")).intValue();
        } catch (Exception ex) {
            logger.error(ex.getMessage());
        }

        // compute start and end index
        startIndex = indexPage * interval + 1;
        endIndex = startIndex + interval - 1;

        equipments = maintainableMgr.getEquipmentsByInterval(startIndex, endIndex);

        // compute number of pages
        equipmentsNumber = maintainableMgr.getEquipmentsNumber();
        numberPages = (int) (equipmentsNumber / interval);
        if ((equipmentsNumber % interval) > 0) {
            numberPages++;
        }

        // compute pages i'm view ten links to view ten page 1, 2, 3, ...., 9 when click on page index 9 he view next ten 11, 12, .....,19
        startPage = indexPage - 7;
        if (startPage < 0) {
            startPage = 0;
        }
        endPage = indexPage + 7;
        if (endPage > numberPages) {
            endPage = numberPages;
        }

        request.setAttribute("data", equipments);
        request.setAttribute("numberPages", numberPages);
        request.setAttribute("index", indexPage);
        request.setAttribute("startPage", startPage);
        request.setAttribute("endPage", endPage);
    }

    public static void setRequestByBrandsInfo(HttpServletRequest request, int interval) {
        int indexPage = 0;
        int startIndex, endIndex, numberPages, startPage, endPage;
        long brandsNumber;
        Vector brands;

        try {
            indexPage = Integer.valueOf(request.getParameter("index")).intValue();
        } catch (Exception ex) {
            logger.error(ex.getMessage());
        }

        // compute start and end index
        startIndex = indexPage * interval + 1;
        endIndex = startIndex + interval - 1;

        brands = maintainableMgr.getBrandsByInterval(startIndex, endIndex);

        // compute number of pages
        brandsNumber = maintainableMgr.getBrandsNumber();
        numberPages = (int) (brandsNumber / interval);
        if ((brandsNumber % interval) > 0) {
            numberPages++;
        }

        // compute pages i'm view ten links to view ten page 1, 2, 3, ...., 9 when click on page index 9 he view next ten 11, 12, .....,19
        startPage = indexPage - 7;
        if (startPage < 0) {
            startPage = 0;
        }
        endPage = indexPage + 7;
        if (endPage > numberPages) {
            endPage = numberPages;
        }

        request.setAttribute("data", brands);
        request.setAttribute("numberPages", numberPages);
        request.setAttribute("index", indexPage);
        request.setAttribute("startPage", startPage);
        request.setAttribute("endPage", endPage);
    }

    public static void setRequestBySparePartsInfo(HttpServletRequest request, int interval) {
        String spareName = request.getParameter("spareName");
        String itemForm = request.getParameter("itemForm");
        String storeCode = request.getParameter("storeCode");
        String branchCode = request.getParameter("branchCode");
        String codeOrName = request.getParameter("codeOrName");
        String codes = request.getParameter("codes").trim();

        String[] arrCodes = null;
        if (!codes.equals("")) {
            arrCodes = codes.split(" ");
        }
        spareName = Tools.getRealChar(spareName);

        int indexPage = 0;
        int startIndex, endIndex, numberPages, startPage, endPage;
        long sparePartsNumber;
        Vector spareParts;

        try {
            indexPage = Integer.valueOf(request.getParameter("index")).intValue();
        } catch (Exception ex) {
            logger.error(ex.getMessage());
        }

        // compute start and end index
        startIndex = indexPage * interval + 1;
        endIndex = startIndex + interval - 1;

        spareParts = sparePartsMgr.getSparePartsByInterval(branchCode, storeCode, itemForm, codeOrName, spareName, arrCodes, startIndex, endIndex);

        // compute number of pages
        sparePartsNumber = sparePartsMgr.getSparePartsNumber(branchCode, storeCode, itemForm, codeOrName, spareName, arrCodes);
        numberPages = (int) (sparePartsNumber / interval);
        if ((sparePartsNumber % interval) > 0) {
            numberPages++;
        }

        // compute pages i'm view ten links to view ten page 1, 2, 3, ...., 9 when click on page index 9 he view next ten 11, 12, .....,19
        startPage = indexPage - 7;
        if (startPage < 0) {
            startPage = 0;
        }
        endPage = indexPage + 7;
        if (endPage > numberPages) {
            endPage = numberPages;
        }

        for (int i = 0; i < spareParts.size(); i++) {
            WebBusinessObject wbo = (WebBusinessObject) spareParts.get(i);
            try {
                wbo.setAttribute("itemQuantity", itemsBranchMgr.getQuantity(wbo.getAttribute("itemForm").toString(), wbo.getAttribute("itemCode").toString(), wbo.getAttribute("code").toString()));
            } catch (SQLException ex) {
                java.util.logging.Logger.getLogger(Tools.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        request.setAttribute("data", spareParts);
        request.setAttribute("numberPages", numberPages);
        request.setAttribute("index", indexPage);
        request.setAttribute("startPage", startPage);
        request.setAttribute("endPage", endPage);

        request.setAttribute("itemForm", itemForm);
        request.setAttribute("storeCode", storeCode);
        request.setAttribute("branchCode", branchCode);
        request.setAttribute("codeOrName", codeOrName);
        request.setAttribute("codes", codes);
    }

    public static int convertInt(String value) {
        try {
            return Integer.valueOf(value).intValue();
        } catch (NumberFormatException ex) {
        }
        return 0;
    }

    public static long convertLong(String value) {
        try {
            return Long.valueOf(value).longValue();
        } catch (NumberFormatException ex) {
        }

        return 0;
    }

    public static float convertFloat(String value) {
        try {
            return Float.valueOf(value).floatValue();
        } catch (NumberFormatException ex) {
        }
        return 0;
    }

    public static String[] removeDuplicate(String[] values) {
        Vector<String> returnedValues = new Vector<String>();
        String[] temp = new String[values.length];
        for (int i = 0; i < values.length; i++) {
            temp[i] = values[i];
        }
        String value;
        for (int i = 0; i < temp.length; i++) {
            value = temp[i];
            if (!value.equals("**********")) {
                for (int j = i + 1; j < temp.length; j++) {
                    if (value.equals(temp[j])) {
                        temp[j] = "**********";
                    }
                }
                returnedValues.add(value);
            }
        }
        String[] returned = new String[returnedValues.size()];
        for (int i = 0; i < returned.length; i++) {
            returned[i] = returnedValues.get(i);
        }
        return returned;
    }

    public static double sumOf(double[] costs, String[] codes, String code) {
        double totalSum = 0;
        double cost;
        for (int i = 0; i < codes.length; i++) {
            if (codes[i].equals(code)) {
                cost = costs[i];
                totalSum += cost;
            }
        }
        return totalSum;
    }

    public static double round(double number, int decimalPlace) {
        double rounded = 0.00;
        double modifier = Math.pow(10.0, decimalPlace);

        try {
            rounded = Math.round(number * modifier) / modifier;
        } catch (Exception ex) {
        }

        return rounded;
    }

    public static String getRealChar(String intChar) {
        String temp = "";
        char c;
        if (intChar != null && !intChar.equals("")) {
            String[] parts = intChar.split(",");
            intChar = "";
            for (int i = 0; i < parts.length; i++) {
                try {
                    c = (char) new Integer(parts[i]).intValue();
                    temp += c;
                } catch (Exception ex) {
                }
            }
        }
        return temp;
    }

    public static Vector getMapVector(Vector vec) {
        if (vec != null && vec.size() > 0) {
            WebBusinessObject wbo = new WebBusinessObject();
            Vector HashtableVec = new Vector();
            for (int i = 0; i < vec.size(); i++) {
                wbo = (WebBusinessObject) vec.get(i);
                HashtableVec.add(wbo.getContents());
            }
            return HashtableVec;
        }
        return new Vector();
    }

    public static void createPdfReport(String reportName, Map parameters, Collection dataSource, ServletContext context, HttpServletResponse response, HttpServletRequest request) throws IOException {

        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String companyName = metaMgr.getCompanyNameForLogo();
        String logoName = "logo";
        
        if (companyName != null) {
            logoName+="-"+companyName+".png";
        } else {
            logoName = "logo.png";
        }
        // get Logo
//        Hashtable logos = (Hashtable) request.getSession().getAttribute("logos");
//        String logoName = (String) logos.get("headReport3");

        /*String reportFileNameSource = context.getRealPath(getFileSeparator() + "reports" + getFileSeparator() + reportName + ".jrxml");
        String reportFileName = context.getRealPath(getFileSeparator() + "reports" + getFileSeparator() + reportName + ".jasper");
        String subReportDir = context.getRealPath(getFileSeparator() + "reports") + getFileSeparator();
        String logoPath = context.getRealPath(getFileSeparator() + "images" + getFileSeparator() + logoName);*/
        String reportFileNameSource = context.getRealPath("/" + "reports" + getFileSeparator() + reportName + ".jrxml");
         String reportFileName = context.getRealPath("/" + "reports" + getFileSeparator() + reportName + ".jasper");
         String subReportDir = context.getRealPath("/" + "reports") + getFileSeparator();
         String logoPath = context.getRealPath("/" + "images" + getFileSeparator() + logoName);
        Vector<WebBusinessObject> vec = (Vector<WebBusinessObject>) dataSource;
        // set in map
        if (vec.get(0).getAttribute("logo") != null && !vec.get(0).getAttribute("logo").equals("")) {
            parameters.put("logo", vec.get(0).getAttribute("logo"));
        } else {
            parameters.put("logo", logoPath);
        }
        parameters.put("SUBREPORT_DIR", subReportDir);
        parameters.put("lang", (String) request.getSession().getAttribute("currentMode"));

        try {

            // Compile report if needed
            File reportFileSource = new File(reportFileNameSource);
            if (!reportFileSource.exists()) {
                throw new FileNotFoundException(String.valueOf(reportFileSource));
            }
            File reportFile = new File(reportFileName);
            //if (!reportFile.exists() || reportFileSource.lastModified() > reportFile.lastModified()) {
            JasperCompileManager.compileReportToFile(reportFileNameSource, reportFileName);
            //}

            ServletOutputStream servletOutputStream = response.getOutputStream();
            byte[] bytes;

            bytes = JasperRunManager.runReportToPdf(reportFileName, parameters, new WboCollectionDataSource(dataSource));
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "inline; filename=\"" + reportName.toUpperCase() + ".pdf\"");
            response.setContentLength(bytes.length);
            servletOutputStream.write(bytes, 0, bytes.length);
            servletOutputStream.flush();
            servletOutputStream.close();

        } catch (FileNotFoundException ex) {
            logger.error(ex.getMessage());
        } catch (IOException ex) {
            logger.error(ex.getMessage());
        } catch (JRException ex) {
            logger.error(ex.getMessage());
        }
    }

    public static void createPdfReportFromComapny(String reportName, Map parameters, Collection dataSource, ServletContext context, HttpServletResponse response, HttpServletRequest request, String logoName) throws IOException {

        MetaDataMgr metaMgr = MetaDataMgr.getInstance();

        /*String reportFileNameSource = context.getRealPath("/" + "reports" + getFileSeparator() + reportName + ".jrxml");
         String reportFileName = context.getRealPath("/" + "reports" + getFileSeparator() + reportName + ".jasper");
         String subReportDir = context.getRealPath("/" + "reports") + getFileSeparator();
         String logoPath = context.getRealPath("/" + "images" + getFileSeparator() + logoName);*/
        String reportFileNameSource = context.getRealPath("//" + "reports" + "//" + reportName + ".jrxml");
        String reportFileName = context.getRealPath("//" + "reports" + "//" + reportName + ".jasper");
        String subReportDir = context.getRealPath("//" + "reports") + "//";
        String logoPath = context.getRealPath("//" + "images" + "//" + logoName);

        Vector<WebBusinessObject> vec = (Vector<WebBusinessObject>) dataSource;

        parameters.put("SUBREPORT_DIR", subReportDir);
        parameters.put("logo", logoPath);

        try {
            // Compile report if needed
            File reportFileSource = new File(reportFileNameSource);
            if (!reportFileSource.exists()) {
                throw new FileNotFoundException(String.valueOf(reportFileSource));
            }

            File reportFile = new File(reportFileName);

            JasperCompileManager.compileReportToFile(reportFileNameSource, reportFileName);

            ServletOutputStream servletOutputStream = response.getOutputStream();
            byte[] bytes;

            bytes = JasperRunManager.runReportToPdf(reportFileName, parameters, new WboCollectionDataSource(dataSource));
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "inline; filename=\"" + reportName.toUpperCase() + ".pdf\"");
            response.setContentLength(bytes.length);
            servletOutputStream.write(bytes, 0, bytes.length);
            servletOutputStream.flush();
            servletOutputStream.close();

        } catch (FileNotFoundException ex) {
            logger.error(ex.getMessage());
        } catch (IOException ex) {
            logger.error(ex.getMessage());
        } catch (JRException ex) {
            logger.error(ex.getMessage());
        }
    }

    public static void createPdfBeanReport(String reportName, Map parameters, Collection dataSource, ServletContext context, HttpServletResponse response, HttpServletRequest request) throws IOException {

        // get Logo
        Hashtable logos = (Hashtable) request.getSession().getAttribute("logos");
        String logoName = (String) logos.get("headReport3");

        String reportFileNameSource = context.getRealPath(getFileSeparator() + "reports" + getFileSeparator() + reportName + ".jrxml");
        String reportFileName = context.getRealPath(getFileSeparator() + "reports" + getFileSeparator() + reportName + ".jasper");
        String subReportDir = context.getRealPath(getFileSeparator() + "reports") + getFileSeparator();
        String logoPath = context.getRealPath(getFileSeparator() + "images" + getFileSeparator() + logoName);

        // set in map
        parameters.put("logo", logoPath);
        parameters.put("SUBREPORT_DIR", subReportDir);
        parameters.put("lang", (String) request.getSession().getAttribute("currentMode"));

        try {

            // Compile report if needed
            File reportFileSource = new File(reportFileNameSource);
            if (!reportFileSource.exists()) {
                throw new FileNotFoundException(String.valueOf(reportFileSource));
            }
            File reportFile = new File(reportFileName);
            if (!reportFile.exists() || reportFileSource.lastModified() > reportFile.lastModified()) {
                JasperCompileManager.compileReportToFile(reportFileNameSource, reportFileName);
            }

            ServletOutputStream servletOutputStream = response.getOutputStream();
            byte[] bytes = null;

            bytes = JasperRunManager.runReportToPdf(reportFileName, parameters, new JRBeanCollectionDataSource(dataSource));
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "inline; filename=\"" + reportName + ".pdf\"");
            response.setContentLength(bytes.length);
            servletOutputStream.write(bytes, 0, bytes.length);
            servletOutputStream.flush();
            servletOutputStream.close();

        } catch (FileNotFoundException ex) {
            logger.error(ex.getMessage());
        } catch (IOException ex) {
            logger.error(ex.getMessage());
        } catch (JRException ex) {
            logger.error(ex.getMessage());
        }
    }

    public static void exportPdfReport(String reportName,
            Map parameters,
            Collection dataSource) {

        String userHome = System.getProperty("user.home");
        String logoName = "small_lehaa_Logo.jpg";

        String reportFileNameSource = userHome + getFileSeparator() + "reports" + getFileSeparator() + reportName + ".jrxml";
        String reportFileName = userHome + getFileSeparator() + "reports" + getFileSeparator() + reportName + ".jasper";
        String subReportDir = userHome + getFileSeparator() + "reports" + getFileSeparator();
        String logoPath = userHome + getFileSeparator() + "images" + getFileSeparator() + logoName;

        // set in map
        parameters.put("logo", logoPath);
        parameters.put("SUBREPORT_DIR", subReportDir);

        try {

            // Compile report if needed
            File reportFileSource = new File(reportFileNameSource);
            if (!reportFileSource.exists()) {
                throw new FileNotFoundException(String.valueOf(reportFileSource));
            }
            File reportFile = new File(reportFileName);
            if (!reportFile.exists() || reportFileSource.lastModified() > reportFile.lastModified()) {
                JasperCompileManager.compileReportToFile(reportFileNameSource, reportFileName);
            }

            JasperPrint jasperPrint = JasperFillManager.fillReport(
                    reportFileName,
                    parameters,
                    new WboCollectionDataSource(dataSource));

            JRPdfExporter pdfExporter = new JRPdfExporter();
            pdfExporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
            pdfExporter.setParameter(JRExporterParameter.OUTPUT_FILE_NAME, "D:/" + reportName + ".pdf");

            pdfExporter.exportReport();

        } catch (FileNotFoundException ex) {
            logger.error(ex.getMessage());
        } catch (JRException ex) {
            logger.error(ex.getMessage());
        }

    }

    public static String getFileSeparator() {
        return "/";
        
//return System.getProperty("file.separator");
    }

    public static void printImage(HttpServletResponse response, ServletContext context, InputStream inputStream) {
        Map parameters = new HashMap();

        try {

            ServletOutputStream servletOutputStream = response.getOutputStream();
            byte[] bytes = null;

            String reportFileNameSource = context.getRealPath("/reports/" + "PrintImage" + ".jrxml");
            String reportFileName = context.getRealPath("/reports/" + "PrintImage" + ".jasper");

            parameters.put("IMAGE", inputStream);

            // Compile report if needed
            File reportFileSource = new File(reportFileNameSource);
            if (!reportFileSource.exists()) {
                throw new FileNotFoundException(String.valueOf(reportFileSource));
            }
            File reportFile = new File(reportFileName);
            if (!reportFile.exists() || reportFileSource.lastModified() > reportFile.lastModified()) {
                JasperCompileManager.compileReportToFile(reportFileNameSource, reportFileName);
            }

            bytes = JasperRunManager.runReportToPdf(reportFileName, parameters, new JREmptyDataSource());
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "inline; filename=\"PrintImage.pdf\"");
            response.setContentLength(bytes.length);
            servletOutputStream.write(bytes, 0, bytes.length);
            servletOutputStream.flush();
            servletOutputStream.close();
        } catch (Exception ex) {
            logger.error(ex.getMessage());
        }
    }

    private static byte[] getBytesFromFile(java.io.File file) throws IOException {
        java.io.InputStream is = new java.io.FileInputStream(file);

        // Get the size of the file
        long length = file.length();

        if (length > Integer.MAX_VALUE) {
            // File is too large
        }

        // Create the byte array to hold the data
        byte[] bytes = new byte[(int) length];

        // Read in the bytes
        int offset = 0;
        int numRead = 0;
        while (offset < bytes.length
                && (numRead = is.read(bytes, offset, bytes.length - offset)) >= 0) {
            offset += numRead;
        }

        return bytes;
    }

    public static Date getSqlDate(String strDate) {
        strDate = strDate.replaceAll("-", "/");
        DateParser dateParser = new DateParser();
        Date date = dateParser.formatSqlDate(strDate);
        return date;
    }

    public static Date getBeginDate(String strBeginDate) {
        return getSqlDate(strBeginDate);
    }

    public static Date getEndDate(String strEndDate) {
        Date endDate = getSqlDate(strEndDate);
        endDate.setDate(endDate.getDate() + 1);
        return endDate;
    }

    public static String getDate(long time) {
        java.util.Date date = Calendar.getInstance().getTime();
        int year, mon, day;
        date.setTime(time);
        year = date.getYear() + 1900;
        mon = date.getMonth() + 1;
        day = date.getDate();
        return (year + " / " + mon + " / " + day);
    }

    public static String getDate(String longTime) {
        long time = convertLong(longTime);

        return getDate(time);
    }

    public static long timeNow() {
        java.util.Date date = Calendar.getInstance().getTime();
        long nowTime = date.getTime();
        return nowTime;
    }

    public static String getCurrency(String number) {
        Double currency = new Double(Double.parseDouble(number));
        NumberFormat currencyFormatter;
        currencyFormatter = NumberFormat.getCurrencyInstance(new Locale("EN", "EG"));
        String currencyOut = currencyFormatter.format(currency);
        currencyOut = currencyOut.substring(3);
        return currencyOut;
    }

    public static boolean isFound(String value, Vector<String> values) {
        if (values != null) {
            for (String string : values) {
                if (string.equals(value)) {
                    return true;
                }
            }
        }
        return false;
    }

    public static boolean isFound(String value, String[] values) {
        if (values != null) {
            for (String string : values) {
                if (string.equals(value)) {
                    return true;
                }
            }
        }
        return false;
    }

    public static boolean isFound(String value, Vector<WebBusinessObject> values, String attributeKey) {
        String attributeValue;
        if (values != null) {
            for (WebBusinessObject wbo : values) {
                attributeValue = (String) wbo.getAttribute(attributeKey);
                if (attributeValue != null && attributeValue.equals(value)) {
                    return true;
                }
            }
        }
        return false;
    }

    public static boolean isFound(int value, Vector<Integer> values) {
        if (values != null) {
            for (Integer integer : values) {
                if (integer.intValue() == value) {
                    return true;
                }
            }
        }
        return false;
    }

    public static Vector<String> getDifference(Vector<String> orignalList, Vector<String> newList) {
        Vector<String> resualt = new Vector<String>();

        if (orignalList != null && newList != null) {
            for (String string : orignalList) {
                if (!newList.contains(string)) {
                    resualt.addElement(string);
                }
            }
        }

        return resualt;
    }

    public static Vector<String> getDifference(String[] orignalList, String[] newList) {
        Vector<String> resualt = new Vector<String>();

        if (orignalList != null && newList != null) {
            for (String stringOrignal : orignalList) {
                if (!isFound(stringOrignal, newList)) {
                    resualt.addElement(stringOrignal);
                }
            }
        }

        return resualt;
    }

    public static Hashtable<String, String> toHashtable(Vector<WebBusinessObject> list, String keyName, String valueName) {
        Hashtable<String, String> hashtable = new Hashtable<String, String>();

        for (WebBusinessObject wbo : list) {
            try {
                hashtable.put((String) wbo.getAttribute(keyName), (String) wbo.getAttribute(valueName));
            } catch (Exception ex) {
            }
        }

        return hashtable;
    }

    public static void createPdfReport(String reportName, HashMap reportParams, ServletContext servletContext, HttpServletResponse response, HttpServletRequest request, Connection conn) {
        // get Logo
        Hashtable logos = (Hashtable) request.getSession().getAttribute("logos");
        String logoName = (String) logos.get("headReport3");

        String reportFileNameSource = servletContext.getRealPath(getFileSeparator() + "reports" + getFileSeparator() + reportName + ".jrxml");
        String reportFileName = servletContext.getRealPath(getFileSeparator() + "reports" + getFileSeparator() + reportName + ".jasper");
        String subReportDir = servletContext.getRealPath(getFileSeparator() + "reports") + getFileSeparator();
        String logoPath = servletContext.getRealPath(getFileSeparator() + "images" + getFileSeparator() + logoName);

        // set in map
        reportParams.put("logo", logoPath);
        reportParams.put("SUBREPORT_DIR", subReportDir);

        try {

            // Compile report if needed
            File reportFileSource = new File(reportFileNameSource);
            if (!reportFileSource.exists()) {
                throw new FileNotFoundException(String.valueOf(reportFileSource));
            }
            File reportFile = new File(reportFileName);
            if (!reportFile.exists() || reportFileSource.lastModified() > reportFile.lastModified()) {
                JasperCompileManager.compileReportToFile(reportFileNameSource, reportFileName);
            }

            ServletOutputStream servletOutputStream = response.getOutputStream();
            byte[] bytes = null;

            bytes = JasperRunManager.runReportToPdf(reportFileName, reportParams, conn);

            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "inline; filename=\"" + reportName + ".pdf\"");
            response.setContentLength(bytes.length);
            servletOutputStream.write(bytes, 0, bytes.length);
            servletOutputStream.flush();
            servletOutputStream.close();

        } catch (FileNotFoundException ex) {
            logger.error(ex.getMessage());
        } catch (IOException ex) {
            logger.error(ex.getMessage());
        } catch (JRException ex) {
            logger.error(ex.getMessage());
        }
    }

    public static void createPdfReportFormCompanyConfig(String reportName, Map parameters, Collection dataSource, ServletContext context, HttpServletResponse response, HttpServletRequest request) throws IOException {
        MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();

        // get Logo
        String logoName = (String) metaDataMgr.getLogos().get("headReport3");

        //get Comapny Title
        String CompanyName = (String) metaDataMgr.getLogos().get("ReportTitle");

        String reportFileNameSource = context.getRealPath(getFileSeparator() + "reports" + getFileSeparator() + reportName + ".jrxml");
        String reportFileName = context.getRealPath(getFileSeparator() + "reports" + getFileSeparator() + reportName + ".jasper");
        String subReportDir = context.getRealPath(getFileSeparator() + "reports") + getFileSeparator();
        String logoPath = context.getRealPath(getFileSeparator() + "images" + getFileSeparator() + logoName);

        //Report Data
        Vector<WebBusinessObject> vec = (Vector<WebBusinessObject>) dataSource;

        parameters.put("logo", logoName);
        parameters.put("CompanyName", CompanyName);
        parameters.put("SUBREPORT_DIR", subReportDir);
        parameters.put("lang", (String) request.getSession().getAttribute("currentMode"));

        try {

            // Compile report if needed
            File reportFileSource = new File(reportFileNameSource);
            if (!reportFileSource.exists()) {
                throw new FileNotFoundException(String.valueOf(reportFileSource));
            }

            File reportFile = new File(reportFileName);
            JasperCompileManager.compileReportToFile(reportFileNameSource, reportFileName);

            ServletOutputStream servletOutputStream = response.getOutputStream();
            byte[] bytes;

            bytes = JasperRunManager.runReportToPdf(reportFileName, parameters, new WboCollectionDataSource(dataSource));
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "inline; filename=\"" + reportName.toUpperCase() + ".pdf\"");
            response.setContentLength(bytes.length);
            servletOutputStream.write(bytes, 0, bytes.length);
            servletOutputStream.flush();
            servletOutputStream.close();

        } catch (FileNotFoundException ex) {
            logger.error(ex.getMessage());
        } catch (IOException ex) {
            logger.error(ex.getMessage());
        } catch (JRException ex) {
            logger.error(ex.getMessage());
        }
    }

    public static Filter getPaginationInfo(HttpServletRequest request, HttpServletResponse response) {

        // get parameters
        String indexAsString = request.getParameter("Index");
        String rowsPerPageAsString = request.getParameter("rowsPerPage");

        String[] fieldNames = request.getParameterValues("fieldName");
        String[] fieldValues = request.getParameterValues("fieldValue");
        /*String fieldNames = request.getParameter("fieldName");
         String fieldValues = request.getParameter("fieldValue");*/

        String operator = "LIKE";
        operator = request.getParameter("operation");
        if (operator == null || operator.equalsIgnoreCase("")) {

            operator = "LIKE";
        }

        // get current page index
        short indexPage = 0;

        try {
            indexPage = Short.parseShort(indexAsString);
        } catch (Exception ex) {
        }

        // Number of rows per page
        short rowsPerPage = PAGINATION_CONSTANT.DEFUALT_COUNT_ROW_PAGE;

        try {
            rowsPerPage = Short.parseShort(rowsPerPageAsString);

            if (rowsPerPage > PAGINATION_CONSTANT.MAX_COUNT_ROW_PAGE) {
                rowsPerPage = PAGINATION_CONSTANT.MAX_COUNT_ROW_PAGE;
            } else if (rowsPerPage < 1) {
                rowsPerPage = PAGINATION_CONSTANT.DEFUALT_COUNT_ROW_PAGE;
            }
        } catch (Exception e) {
        }

        Filter filter = new Filter();
        List<FilterCondition> conditions = new ArrayList<FilterCondition>();

        // add conditions
        String field_value = new String("");
        if (fieldNames != null && fieldNames.length > 0) {
            for (int i = 0; i < fieldNames.length; i++) {
                field_value = Tools.getRealChar((String) fieldValues[i]);
                conditions.add(new FilterCondition(fieldNames[i], field_value, Operations.valueOf(operator)));
            }
        }

        filter.setConditions(conditions);
        filter.setPageIndex(indexPage);
        filter.setCountRowPage(rowsPerPage);
        return filter;
    }

    public static Filter getPaginationInfoForEng(HttpServletRequest request, HttpServletResponse response) {

        // get parameters
        String indexAsString = request.getParameter("Index");
        String rowsPerPageAsString = request.getParameter("rowsPerPage");

        String[] fieldNames = request.getParameterValues("fieldName");
        String[] fieldValues = request.getParameterValues("fieldValue");
        /*String fieldNames = request.getParameter("fieldName");
         String fieldValues = request.getParameter("fieldValue");*/

        String operator = "LIKE";
        operator = request.getParameter("operation");
        if (operator == null || operator.equalsIgnoreCase("")) {

            operator = "LIKE";
        }

        // get current page index
        short indexPage = 0;

        try {
            indexPage = Short.parseShort(indexAsString);
        } catch (Exception ex) {
        }

        // Number of rows per page
        short rowsPerPage = PAGINATION_CONSTANT.DEFUALT_COUNT_ROW_PAGE;

        try {
            rowsPerPage = Short.parseShort(rowsPerPageAsString);

            if (rowsPerPage > PAGINATION_CONSTANT.MAX_COUNT_ROW_PAGE) {
                rowsPerPage = PAGINATION_CONSTANT.MAX_COUNT_ROW_PAGE;
            } else if (rowsPerPage < 1) {
                rowsPerPage = PAGINATION_CONSTANT.DEFUALT_COUNT_ROW_PAGE;
            }
        } catch (Exception e) {
        }

        Filter filter = new Filter();
        List<FilterCondition> conditions = new ArrayList<FilterCondition>();

        // add conditions
        String field_value = new String("");
        if (fieldNames != null && fieldNames.length > 0) {
            for (int i = 0; i < fieldNames.length; i++) {
                field_value = (String) fieldValues[i];
                conditions.add(new FilterCondition(fieldNames[i], field_value, Operations.valueOf(operator)));
            }
        }

        filter.setConditions(conditions);
        filter.setPageIndex(indexPage);
        filter.setCountRowPage(rowsPerPage);
        return filter;
    }

    public static Filter getPaginationInfoBySites(HttpServletRequest request, HttpServletResponse response, String sites) {

        // get parameters
        String indexAsString = request.getParameter("Index");
        String rowsPerPageAsString = request.getParameter("rowsPerPage");

        /*String[] fieldNames = request.getParameterValues("fieldName");
         String[] fieldValues = request.getParameterValues("fieldValue");*/
        String fieldNames = request.getParameter("fieldName");
        String fieldValues = request.getParameter("fieldValue");

        String operator = "LIKE";
        operator = request.getParameter("operation");
        if (operator == null || operator.equalsIgnoreCase("")) {

            operator = "LIKE";
        }

        // get current page index
        short indexPage = 0;

        try {
            indexPage = Short.parseShort(indexAsString);
        } catch (Exception ex) {
        }

        // Number of rows per page
        short rowsPerPage = PAGINATION_CONSTANT.DEFUALT_COUNT_ROW_PAGE;

        try {
            rowsPerPage = Short.parseShort(rowsPerPageAsString);

            if (rowsPerPage > PAGINATION_CONSTANT.MAX_COUNT_ROW_PAGE) {
                rowsPerPage = PAGINATION_CONSTANT.MAX_COUNT_ROW_PAGE;
            } else if (rowsPerPage < 1) {
                rowsPerPage = PAGINATION_CONSTANT.DEFUALT_COUNT_ROW_PAGE;
            }
        } catch (Exception e) {
        }

        Filter filter = new Filter();
        List<FilterCondition> conditions = new ArrayList<FilterCondition>();

        // add conditions
        String field_value = new String("");
        //for (int i = 0; i < fieldNames.length; i++) {

        field_value = Tools.getRealChar((String) fieldValues);
        conditions.add(new FilterCondition(fieldNames, field_value, Operations.valueOf(operator)));

        //}
        conditions.add(new FilterCondition("SITE", sites, Operations.IN));

        filter.setConditions(conditions);
        filter.setPageIndex(indexPage);
        filter.setCountRowPage(rowsPerPage);
        return filter;
    }

    public static SimpleDateFormat getSimpleDateFormat() {
        return new SimpleDateFormat("yyyy/MM/dd hh:mm:ss a");
    }

    public static SimpleDateFormat getSimpleDateFormatForTimestamp() {
        return new SimpleDateFormat("yyyy/MM/dd HH:mm:ss.s");
    }

    public static java.util.Date stringToDate(String string) {
        SimpleDateFormat simpleDateFormat;
        if (string != null && string.indexOf(".") == -1) {
            simpleDateFormat = getSimpleDateFormat();
        } else {
            simpleDateFormat = getSimpleDateFormatForTimestamp();
        }

        try {
            string = string.replaceAll("-", "/");
            if (string.indexOf(" ") == -1) {
                string = string + " 12:00:00 AM";
            }
            return simpleDateFormat.parse(string);
        } catch (Exception ex) {
            logger.error(ex.getMessage());
        }

        return null;
    }

    public static String formatDuration(String duration) {

        duration = duration.replaceAll("days", "D");
        duration = duration.replaceAll("hours", "H");
        duration = duration.replaceAll("minutes", "M");
        duration = duration.replaceAll("seconds", "S");

        duration = duration.replaceAll("day", "D");
        duration = duration.replaceAll("hour", "H");
        duration = duration.replaceAll("minute", "M");
        duration = duration.replaceAll("second", "S");

        return duration;
    }

    public static String getFrequencyType(String frequencyCodeStr, String language) {

        String frequencyType = "";

        if (frequencyCodeStr != null && !frequencyCodeStr.equals("")) {

            Integer frequencyCodeInt = new Integer(frequencyCodeStr);

            if (language.equalsIgnoreCase("En")) {   // English
                switch (frequencyCodeInt) {
                    case 0:
                        frequencyType = "Hour";
                        break;

                    case 1:
                        frequencyType = "Day";
                        break;

                    case 2:
                        frequencyType = "Week";
                        break;

                    case 3:
                        frequencyType = "Month";
                        break;

                    case 4:
                        frequencyType = "Year";
                        break;

                    default:
                        frequencyType = "";

                }

            } else { // Arabic

                switch (frequencyCodeInt) {
                    case 0:
                        frequencyType = "\u0633\u0627\u0639\u0629";
                        break;

                    case 1:
                        frequencyType = "\u064A\u0648\u0645";
                        break;

                    case 2:
                        frequencyType = "\u0623\u0633\u0628\u0648\u0639";
                        break;

                    case 3:
                        frequencyType = "\u0634\u0647\u0631";
                        break;

                    case 4:
                        frequencyType = "\u0633\u0646\u0629";
                        break;

                    default:
                        frequencyType = "";

                }

            }

        }

        return frequencyType;

    }

    public static String getJSONObjectAsString(WebBusinessObject wbo) {

        String strJSONObj = "";

        if (wbo != null) {
            strJSONObj = JSONValue.toJSONString(wbo.getContents());
        }

        return strJSONObj;
    }
    public static String getJSONObjectAsString(LiteWebBusinessObject wbo) {

        String strJSONObj = "";

        if (wbo != null) {
            strJSONObj = JSONValue.toJSONString(wbo.getContents());
        }
        return strJSONObj;
    }

    public static String getJSONArrayAsString(List WboList) {

        String strJSONArray = "";

        if (WboList != null && !WboList.isEmpty()) {

            List aList = new ArrayList();
            Iterator it = WboList.iterator();
            WebBusinessObject wbo;

            while (it.hasNext()) {
                wbo = (WebBusinessObject) it.next();
                aList.add(wbo.getContents());

            }

            strJSONArray = JSONValue.toJSONString(aList);
        }

        return strJSONArray;

    }
    public static String getLiteJSONArrayAsString(List WboList) {

        String strJSONArray = "";

        if (WboList != null && !WboList.isEmpty()) {

            List aList = new ArrayList();
            Iterator it = WboList.iterator();
            LiteWebBusinessObject wbo;

            while (it.hasNext()) {
                wbo = (LiteWebBusinessObject) it.next();
                aList.add(wbo.getContents());

            }

            strJSONArray = JSONValue.toJSONString(aList);
        }

        return strJSONArray;

    }

    public static String getJSONArrayAsString2(List WboList) {

        String strJSONArray = "";
        String data = "";
        String data2 = "";
        if (WboList != null && !WboList.isEmpty()) {

            List aList = new ArrayList();
            Iterator it = WboList.iterator();
            WebBusinessObject wbo;

            while (it.hasNext()) {
                wbo = (WebBusinessObject) it.next();
                aList.add(wbo.getContents());

            }
            String jsonName = "{\"data\":";
            String x = "}";
            strJSONArray = JSONValue.toJSONString(aList);

            data = strJSONArray.substring(1, strJSONArray.length() - 1);
            data2 = jsonName + strJSONArray + x;

        }

        return data2;

    }
    
    public static String getJSONArrayAsValuesString(List<WebBusinessObject> wboList) {
        String strJSONArray = "";
        if (wboList != null) {
            List aList = new ArrayList();
            for (WebBusinessObject wbo : wboList) {
                ArrayList<String> values = new ArrayList<>(wbo.getContents().values());
                for (int i = 0; i < values.size(); i++) {
                    values.set(i, "" + values.get(i) + "");
                }
                aList.add(values);
            }
            strJSONArray = JSONValue.toJSONString(aList);
        }
        return strJSONArray;
    }

    public static boolean isNumeric(String inputData) {
        return inputData.matches("[-+]?\\d+(\\.\\d+)?");

    }

    public static String stringToStringDateonly(String string) {
        SimpleDateFormat simpleDateFormat;
        if (string != null && string.indexOf(".") == -1) {
            simpleDateFormat = getSimpleDateFormat();
        } else {
            simpleDateFormat = getSimpleDateFormatForTimestamp();
        }

        try {
            string = string.replaceAll("-", "/");
            if (string.indexOf(" ") == -1) {
                string = string + " 12:00:00 AM";
            }
            java.util.Date tempdate = simpleDateFormat.parse(string);
            simpleDateFormat = getSimpleDateFormatnoTime();
            String Str = simpleDateFormat.format(tempdate);
            return Str;
        } catch (Exception ex) {
            logger.error(ex.getMessage());
        }

        return null;
    }

    public static SimpleDateFormat getSimpleDateFormatnoTime() {
        return new SimpleDateFormat("yyyy/MM/dd");
    }

    public static String getBrowserType(String currValue) {
        String browser = new String("");
        String version = new String("");
        if (currValue != null) {
            if ((currValue.indexOf("MSIE") == -1) && (currValue.indexOf("msie") == -1)) {
                browser = "NS";
                int verPos = currValue.indexOf("/");
                if (verPos != -1) {
                    version = currValue.substring(verPos + 1, verPos + 5);
                }
            } else {
                browser = "IE";
                String tempStr = currValue.substring(currValue.indexOf("MSIE"), currValue.length());
                version = tempStr.substring(4, tempStr.indexOf(";"));

            }

        }
        System.out.println(" now browser type is " + browser + " " + version);

        return browser + " " + version;

    }

    public static String getBrowserInfo(String Information) {
        String browsername = "";
        String browserversion = "";
        String browser = Information;
        if (browser.contains("MSIE")) {
            String subsString = browser.substring(browser.indexOf("MSIE"));
            String Info[] = (subsString.split(";")[0]).split(" ");
            browsername = Info[0];
            browserversion = Info[1];
        } else if (browser.contains("Firefox")) {

            String subsString = browser.substring(browser.indexOf("Firefox"));
            String Info[] = (subsString.split(" ")[0]).split("/");
            browsername = Info[0];
            browserversion = Info[1];
        } else if (browser.contains("Chrome")) {

            String subsString = browser.substring(browser.indexOf("Chrome"));
            String Info[] = (subsString.split(" ")[0]).split("/");
            browsername = Info[0];
            browserversion = Info[1];
        } else if (browser.contains("Opera")) {

            String subsString = browser.substring(browser.indexOf("Opera"));
            String Info[] = (subsString.split(" ")[0]).split("/");
            browsername = Info[0];
            browserversion = Info[1];
        } else if (browser.contains("Safari")) {

            String subsString = browser.substring(browser.indexOf("Safari"));
            String Info[] = (subsString.split(" ")[0]).split("/");
            browsername = Info[0];
            browserversion = Info[1];
        }
        return browsername + "-" + browserversion;
    }

    public static double round(double unrounded, int precision, int roundingMode) {
        BigDecimal bd = new BigDecimal(unrounded);
        BigDecimal rounded = bd.setScale(precision, roundingMode);
        return rounded.doubleValue();
    }

    public static void getTaskComments(HttpServletRequest request, int interval) {

        WFTaskCommentsMgr wfTaskCommentsMgr = WFTaskCommentsMgr.getInstance();
        String businessObjectId = request.getParameter("businessObjectId");
        String objectType = request.getParameter("objectType");

        int indexPage = 0;
        int startIndex, endIndex, numberPages, startPage, endPage;
        long wfTaskCommentsNumber;
        Vector wfTaskCommentsParts;

        try {
            indexPage = Integer.valueOf(request.getParameter("Index")).intValue();
        } catch (Exception ex) { //logger.error(ex.getMessage());
            System.out.println("message................");
        }

        // compute start and end index
        startIndex = indexPage * interval + 1;
        endIndex = startIndex + interval - 1;

        wfTaskCommentsParts = wfTaskCommentsMgr.getAllTaskComments(businessObjectId, objectType, startIndex, endIndex);

        // compute number of pages
        wfTaskCommentsNumber = wfTaskCommentsMgr.getTaskCommentsNumber(businessObjectId, objectType);
        numberPages = (int) (wfTaskCommentsNumber / interval);
        if ((wfTaskCommentsNumber % interval) > 0) {
            numberPages++;
        }

        // compute pages i'm view ten links to view ten page 1, 2, 3, ...., 9 when click on page index 9 he view next ten 11, 12, .....,19
        startPage = indexPage - 7;
        if (startPage < 0) {
            startPage = 0;
        }
        endPage = indexPage + 7;
        if (endPage > numberPages) {
            endPage = numberPages;
        }

        request.setAttribute("data", wfTaskCommentsParts);
        request.setAttribute("numberPages", numberPages);
        request.setAttribute("index", indexPage);
        request.setAttribute("startPage", startPage);
        request.setAttribute("endPage", endPage);

    }

    public static void createClientComplaintWithCommentsPdfReport(HttpServletResponse response, HttpServletRequest request, boolean sendByemail) throws Exception {
        ServletContext context = request.getSession().getServletContext();
        String reportName = "ClientComplaintWithComments";
        String complaintId = request.getParameter("complaintId");
        String objectType = request.getParameter("objectType");
        Vector<WebBusinessObject> stages;
        Vector<WebBusinessObject> comments;
        List<DateAndTimeControl.CustomDate> customs = new ArrayList<DateAndTimeControl.CustomDate>();
        DateAndTimeControl.CustomDate custom;
        Timestamp beginDate;
        Timestamp endDate;
        String receipId = null;
        String optionOne;
        String managerName = "";
        String receipName = "";
        String statusName = "";
        String statusCode;
        String comment;
        String code;
        WebBusinessObject managerWbo = null;
        WebBusinessObject commentWbo;
        int duration, totalDuration = 0;
        try {
            IssueStatusMgr issueStatusMgr = IssueStatusMgr.getInstance();
            UserMgr userMgr = UserMgr.getInstance();
            CommentsMgr commentsMgr = CommentsMgr.getInstance();
            IssueByComplaintAllCaseMgr issueByComplaintAllCaseMgr = IssueByComplaintAllCaseMgr.getInstance();
            DistributionListMgr distributionListMgr = DistributionListMgr.getInstance();

            Vector complaints = issueByComplaintAllCaseMgr.getOnArbitraryKey(complaintId, "key4");
            WebBusinessObject complaint = (WebBusinessObject) complaints.get(0);
            optionOne = (String) complaint.getAttribute("optionOne");
            WebBusinessObject lastDistribution = distributionListMgr.getLastOwnerForComp(complaintId);

            // set employee responsible
            if (lastDistribution != null) {
                receipId = (String) lastDistribution.getAttribute("receipId");
            }
            if (receipId != null) {
                lastDistribution = userMgr.getOnSingleKey(receipId);
                receipName = (String) lastDistribution.getAttribute("userName");
            }

            // set manager name
            if (optionOne != null) {
                managerWbo = userMgr.getOnSingleKey(optionOne);
            }
            if (managerWbo != null) {
                managerName = (String) managerWbo.getAttribute("userName");
            }

            // get comment
            comment = (String) complaint.getAttribute("comments");

            // get code
            code = complaint.getAttribute("businessID") + "/" + complaint.getAttribute("businessIDbyDate");

            // get status 
            statusCode = (String) complaint.getAttribute("statusCode");
            if (statusCode.equalsIgnoreCase("2")) {
                statusName = "\u0645\u0631\u0633\u0644\u0629";
            } else if (statusCode.equalsIgnoreCase("4")) {
                statusName = "\u062A\u0645 \u0627\u0644\u062A\u0648\u0632\u064A\u0639";
            } else if (statusCode.equalsIgnoreCase("3")) {
                statusName = "\u062A\u0645 \u0627\u0644\u0639\u0644\u0645";
            } else if (statusCode.equalsIgnoreCase("5")) {
                statusName = "\u062A\u0645 \u0627\u0644\u0625\u0644\u063A\u0627\u0621";
            } else if (statusCode.equalsIgnoreCase("6")) {
                statusName = "\u062A\u0645 \u0627\u0644\u0625\u0646\u0647\u0627\u0621";
            } else if (statusCode.equalsIgnoreCase("7")) {
                statusName = "\u062A\u0645 \u0627\u0644\u0625\u063A\u0644\u0627\u0642";
            }

            // set data 
            Vector data = new Vector();
            // set stage data
            stages = issueStatusMgr.getStatusForObject(complaintId);
            // first stage
            WebBusinessObject firstStage = new WebBusinessObject();
            firstStage.setAttribute("caseName", "ط§ظ„طھط³ظ„ظٹظ…");
            firstStage.setAttribute("beginDate", complaint.getAttribute("entryDate"));
            firstStage.setAttribute("endDate", "---");
            firstStage.setAttribute("days", DateAndTimeControl.CustomDate.getAsString(0));
            firstStage.setAttribute("hours", DateAndTimeControl.CustomDate.getAsString(0));
            firstStage.setAttribute("minutes", DateAndTimeControl.CustomDate.getAsString(0));
            stages.insertElementAt(firstStage, 0);
            WebBusinessObject stage;
            for (int i = 1; i < stages.size(); i++) {
                stage = (WebBusinessObject) stages.get(i);
                duration = (Integer) stage.getAttribute("duration");
                totalDuration += duration;
                custom = DateAndTimeControl.getDelayTime(duration);
                beginDate = (Timestamp) stage.getAttribute("beginDate");
                endDate = (Timestamp) stage.getAttribute("endDate");
                if (endDate != null) {
                    stage.setAttribute("endDate", DateAndTimeControl.getDateTimeFormatted((Timestamp) stage.getAttribute("endDate")));
                } else {
                    stage.setAttribute("endDate", "---");
                }
                stage.setAttribute("beginDate", DateAndTimeControl.getDateTimeFormatted((Timestamp) stage.getAttribute("beginDate")));
                stage.setAttribute("days", DateAndTimeControl.CustomDate.getAsString(custom.getDays()));
                stage.setAttribute("hours", DateAndTimeControl.CustomDate.getAsString(custom.getHours()));
                stage.setAttribute("minutes", DateAndTimeControl.CustomDate.getAsString(custom.getMinutes()));
                customs.add(custom);
            }
            // sum total duration
            custom = DateAndTimeControl.getDelayTime(totalDuration);

            // set comment data
            comments = new Vector();
            Vector<WebBusinessObject> commentsData = commentsMgr.getComments(complaintId, objectType, "key1");
            for (WebBusinessObject commentData : commentsData) {
                commentWbo = new WebBusinessObject();
                commentWbo.setAttribute("employee", userMgr.getOnSingleKey((String) commentData.getAttribute("createdBy")).getAttribute("userName").toString());
                commentWbo.setAttribute("entryDate", commentData.getAttribute("creationTime"));
                commentWbo.setAttribute("comment", commentData.getAttribute("comment").toString());
                comments.add(commentWbo);
            }
            Vector<WebBusinessObject> closing = new Vector<WebBusinessObject>();

            WebBusinessObject closwbo = issueStatusMgr.getFinishedMsg(complaintId);
            WebBusinessObject close = new WebBusinessObject();
            if (closwbo != null) {
                close.setAttribute("statusType", "ط¥ظ†ظ‡ط§ط،");
                close.setAttribute("beginDate", closwbo.getAttribute("beginDate"));
                close.setAttribute("statusNote", closwbo.getAttribute("statusNote"));
                close.setAttribute("employee", userMgr.getOnSingleKey((String) closwbo.getAttribute("createdBy")).getAttribute("userName"));

            } else {
                close.setAttribute("statusType", "ط¥ظ†ظ‡ط§ط،");
                close.setAttribute("beginDate", "--");
                close.setAttribute("statusNote", "--");
                close.setAttribute("employee", "--");

            }

            WebBusinessObject finishwbo = issueStatusMgr.getClosedMsg(complaintId);
            WebBusinessObject finish = new WebBusinessObject();
            if (finishwbo != null) {
                finish.setAttribute("statusType", "ط¥ط؛ظ„ط§ظ‚");
                finish.setAttribute("beginDate", finishwbo.getAttribute("beginDate"));
                finish.setAttribute("statusNote", finishwbo.getAttribute("statusNote"));
                finish.setAttribute("employee", userMgr.getOnSingleKey((String) finishwbo.getAttribute("createdBy")).getAttribute("userName"));

            } else {
                finish.setAttribute("statusType", "ط¥ط؛ظ„ط§ظ‚");
                finish.setAttribute("beginDate", "--");
                finish.setAttribute("statusNote", "--");
                finish.setAttribute("employee", "--");

            }

            closing.add(close);
            closing.add(finish);
            WebBusinessObject wbo = new WebBusinessObject();
            wbo.setAttribute("stages", stages);
            wbo.setAttribute("comments", comments);
            wbo.setAttribute("closing", closing);
            data.add(wbo);
            // parameters
            HashMap parameters = new HashMap();
            parameters.put("STATUS_NAME", statusName);
            parameters.put("MANAGER_NAME", managerName);
            parameters.put("RESPONSIBLE_EMPLOYEE_NAME", receipName);
            parameters.put("COMMENT", comment);
            parameters.put("TOTAL_DAYS", DateAndTimeControl.CustomDate.getAsString(custom.getDays()));
            parameters.put("TOTAL_HOURS", DateAndTimeControl.CustomDate.getAsString(custom.getHours()));
            parameters.put("TOTAL_MINUTES", DateAndTimeControl.CustomDate.getAsString(custom.getMinutes()));
            parameters.put("CODE", code);

            // get Logo
            Hashtable logos = (Hashtable) request.getSession().getAttribute("logos");
            String logoName = (String) logos.get("headReport3");

            String reportFileNameSource = context.getRealPath(getFileSeparator() + "reports" + getFileSeparator() + reportName + ".jrxml");
            String reportFileName = context.getRealPath(getFileSeparator() + "reports" + getFileSeparator() + reportName + ".jasper");
            String subReportDir = context.getRealPath(getFileSeparator() + "reports") + getFileSeparator();
            String logoPath = context.getRealPath(getFileSeparator() + "images" + getFileSeparator() + logoName);

            // set in map
            parameters.put("logo", logoPath);
            parameters.put("SUBREPORT_DIR", subReportDir);
            parameters.put("lang", (String) request.getSession().getAttribute("currentMode"));

            // Compile report if needed
            File reportFileSource = new File(reportFileNameSource);
            if (!reportFileSource.exists()) {
                throw new FileNotFoundException(String.valueOf(reportFileSource));
            }
            File reportFile = new File(reportFileName);
            if (!reportFile.exists() || reportFileSource.lastModified() > reportFile.lastModified()) {
                JasperCompileManager.compileReportToFile(reportFileNameSource, reportFileName);
            }

            byte[] bytes;

            bytes = JasperRunManager.runReportToPdf(reportFileName, parameters, new WboCollectionDataSource(data));
            if (sendByemail) {
                SenderConfiurationMgr emailsConfiurationMgr = SenderConfiurationMgr.getCurrentInstance();
                String emails = emailsConfiurationMgr.getEmailsEscalation();
                String title = emailsConfiurationMgr.getTitleEscalation();
//                String body = String.format(emailsConfiurationMgr.getBody(), code);
                String body = emailsConfiurationMgr.getBodyEscalation();
                String web_inf_path = MetaDataMgr.getInstance().getWebInfPath();
                HttpSession session = request.getSession();
                WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                String userHome = (String) loggedUser.getAttribute("userHome");
                String userPath = web_inf_path + "/usr/" + userHome + "/";
                EmailUtility.sendMessage(emails, title, body, userPath, bytes);
            } else {
                ServletOutputStream servletOutputStream = response.getOutputStream();
                response.setContentType("application/pdf");
                response.setHeader("Content-Disposition", "inline; filename=\"" + reportName + ".pdf\"");
                response.setContentLength(bytes.length);
                servletOutputStream.write(bytes, 0, bytes.length);
                servletOutputStream.flush();
                servletOutputStream.close();
            }
        } catch (FileNotFoundException ex) {
            logger.error(ex.getMessage());
        } catch (IOException ex) {
            logger.error(ex.getMessage());
        } catch (JRException ex) {
            logger.error(ex.getMessage());
        } catch (Exception ex) {
            logger.error(ex.getMessage());
        }
    }

    public static void notAcknowledgeReport(String since, HttpServletResponse response) {
        try {
            byte[] bytes = generateNotAcknowledgeReport(since);
            String reportName = "NotAcknowledgeReport";

            ServletOutputStream servletOutputStream = response.getOutputStream();
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "inline; filename=\"" + reportName + ".pdf\"");
            response.setContentLength(bytes.length);
            servletOutputStream.write(bytes, 0, bytes.length);
            servletOutputStream.flush();
            servletOutputStream.close();
        } catch (FileNotFoundException ex) {
            logger.error(ex.getMessage());
        } catch (IOException ex) {
            logger.error(ex.getMessage());
        } catch (Exception ex) {
            logger.error(ex.getMessage());
        }
    }

    public static byte[] generateNotAcknowledgeReport(String since) {
        MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
        IssueByComplaintMgr complaintsMgr = IssueByComplaintMgr.getInstance();
        try {
            Vector<WebBusinessObject> complaints = complaintsMgr.getPreparedNotAcknowledgeComplaintsBySince(since);
            if (!complaints.isEmpty()) {
                HashMap parameters = new HashMap();

                // get Logo
                String logoName = (String) metaDataMgr.getLogos().get("headReport3");

                String reportName = "NotAcknowledgeReport";
                String reportFileNameSource = metaDataMgr.getRealRootPath() + "/reports" + getFileSeparator() + reportName + ".jrxml";
                String reportFileName = metaDataMgr.getRealRootPath() + "/reports" + getFileSeparator() + reportName + ".jasper";
                String subReportDir = metaDataMgr.getRealRootPath() + "/reports" + getFileSeparator();
                String logoPath = metaDataMgr.getRealRootPath() + "/images" + getFileSeparator() + logoName;

                // set in map
                parameters.put("logo", logoPath);
                parameters.put("SUBREPORT_DIR", subReportDir);
                parameters.put("SINCE", "One Hour");

                // Compile report if needed
                File reportFileSource = new File(reportFileNameSource);
                if (!reportFileSource.exists()) {
                    throw new FileNotFoundException(String.valueOf(reportFileSource));
                }
                File reportFile = new File(reportFileName);
                if (!reportFile.exists() || reportFileSource.lastModified() > reportFile.lastModified()) {
                    JasperCompileManager.compileReportToFile(reportFileNameSource, reportFileName);
                }

                byte[] bytes = JasperRunManager.runReportToPdf(reportFileName, parameters, new WboCollectionDataSource(complaints));
                return bytes;
            }
        } catch (Exception ex) {
            logger.error("Fail Send///////////////////, " + ex);
        }
        return null;
    }

    public static byte[] generateCommentsReplyReport() {
        MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
        IssueMgr issueMgr = IssueMgr.getInstance();
        CommentsMgr commentsMgr = CommentsMgr.getInstance();
        UserMgr userMgr = UserMgr.getInstance();

        String period = metaDataMgr.getDelayedTaskPeriod();

        Vector<WebBusinessObject> reportData = new Vector();
        Vector comments = commentsMgr.getIssuesComments(period);

        try {
            if (comments != null && comments.size() > 0) {
                for (int i = 0; i < comments.size(); i++) {
                    Vector IssueCommentsVec = commentsMgr.getOnArbitraryKeyOrdered(comments.get(i).toString(), "key1", "key4");

                    if (IssueCommentsVec.size() > 0 && IssueCommentsVec != null) {

                        WebBusinessObject comment1 = (WebBusinessObject) IssueCommentsVec.get(0);
                        WebBusinessObject comment2 = (WebBusinessObject) IssueCommentsVec.get(1);

                        java.util.Date commDate1 = Tools.stringToDate(comment1.getAttribute("creationTime").toString());
                        java.util.Date commDate2 = Tools.stringToDate(comment2.getAttribute("creationTime").toString());

                        long dateDiff = commDate2.getTime() - commDate1.getTime();
                        long dateLong = dateDiff / (1000 * 60 * 60 * 24);
                        int Days = (int) dateLong;

                        if (Days >= Integer.parseInt(period)) {
                            WebBusinessObject wbo = new WebBusinessObject();
                            WebBusinessObject issueWbo = issueMgr.getOnSingleKey(comment1.getAttribute("clientId").toString());

                            wbo.setAttribute("IssueBusinessID", issueWbo.getAttribute("businessID").toString());
                            WebBusinessObject userWbo = userMgr.getOnSingleKey(comment1.getAttribute("createdBy").toString());
                            wbo.setAttribute("FromUser", userWbo.getAttribute("userName"));
                            userWbo = userMgr.getOnSingleKey(comment2.getAttribute("createdBy").toString());
                            wbo.setAttribute("ToUser", userWbo.getAttribute("userName"));
                            wbo.setAttribute("Comment1", comment1.getAttribute("comment").toString());
                            wbo.setAttribute("Comment2", comment2.getAttribute("comment").toString());
                            wbo.setAttribute("Date1", comment1.getAttribute("creationTime").toString());
                            wbo.setAttribute("Date2", comment2.getAttribute("creationTime").toString());

                            reportData.add(wbo);
                        }
                    }
                }
            }

            HashMap parameters = new HashMap();

            // get Logo
            String logoName = (String) metaDataMgr.getLogos().get("headReport3");

            //ReportName
            String reportName = "DelayedTasksReport";

            //Report paths
            String reportFileNameSource = metaDataMgr.getRealRootPath() + "/reports" + getFileSeparator() + reportName + ".jrxml";
            String reportFileName = metaDataMgr.getRealRootPath() + "/reports" + getFileSeparator() + reportName + ".jasper";
            String subReportDir = metaDataMgr.getRealRootPath() + "/reports" + getFileSeparator();
            String logoPath = metaDataMgr.getRealRootPath() + "/images" + getFileSeparator() + logoName;

            //set in parameters
            parameters.put("logo", logoPath);
            parameters.put("SUBREPORT_DIR", subReportDir);
            parameters.put("period", period);

            // Compile report if needed
            File reportFileSource = new File(reportFileNameSource);
            if (!reportFileSource.exists()) {
                throw new FileNotFoundException(String.valueOf(reportFileSource));
            }

            File reportFile = new File(reportFileName);
            if (!reportFile.exists() || reportFileSource.lastModified() > reportFile.lastModified()) {
                JasperCompileManager.compileReportToFile(reportFileNameSource, reportFileName);
            }

            WboCollectionDataSource itrate = new WboCollectionDataSource(reportData);
            byte[] bytes = JasperRunManager.runReportToPdf(reportFileName, parameters, itrate);
            return bytes;
        } catch (Exception ex) {
            logger.error("Fail To get Comments" + ex);
        }

        return null;
    }

    public static byte[] generateAbstractClientsReport() {
        MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
        ClientMgr clientMgr = ClientMgr.getInstance();

        Vector<WebBusinessObject> reportData = new Vector();
        SenderConfiurationMgr confiuration = SenderConfiurationMgr.getCurrentInstance();
        reportData = clientMgr.getAbstrcatClient(confiuration.getClientEmpGroup());

        try {

            HashMap parameters = new HashMap();

            // get Logo
            String logoName = (String) metaDataMgr.getLogos().get("headReport3");

            //ReportName
            String reportName = "AbstarctClientsReport";

            //Report paths
            String reportFileNameSource = metaDataMgr.getRealRootPath() + "/reports" + getFileSeparator() + reportName + ".jrxml";
            String reportFileName = metaDataMgr.getRealRootPath() + "/reports" + getFileSeparator() + reportName + ".jasper";
            String subReportDir = metaDataMgr.getRealRootPath() + "/reports" + getFileSeparator();
            String logoPath = metaDataMgr.getRealRootPath() + "/images" + getFileSeparator() + logoName;

            //set in parameters
            parameters.put("logo", logoPath);
            parameters.put("SUBREPORT_DIR", subReportDir);

            // Compile report if needed
            File reportFileSource = new File(reportFileNameSource);
            if (!reportFileSource.exists()) {
                throw new FileNotFoundException(String.valueOf(reportFileSource));
            }

            File reportFile = new File(reportFileName);
            if (!reportFile.exists() || reportFileSource.lastModified() > reportFile.lastModified()) {
                JasperCompileManager.compileReportToFile(reportFileNameSource, reportFileName);
            }

            WboCollectionDataSource itrate = new WboCollectionDataSource(reportData);
            byte[] bytes = JasperRunManager.runReportToPdf(reportFileName, parameters, itrate);
            return bytes;
        } catch (Exception ex) {
            logger.error("Fail To get Comments" + ex);
        }

        return null;
    }

    public static void createUnitSideMenu(String Id, String parent, String index, String numberOfUsers, HttpServletRequest request) {
        String dir = "LTR";
        String align = "LEFT";
        ProjectMgr projectMgr = ProjectMgr.getInstance();
        WebBusinessObject wbo = projectMgr.getOnSingleKey(Id);
        String mode = request.getSession().getAttribute("currentMode").toString();
        /**
         * *********** Side Menu ****************
         */
        //open Jar File
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        metaMgr.setMetaData("xfile.jar");
        ParseSideMenu parseSideMenu = new ParseSideMenu();
        Vector userSideMenuVec = parseSideMenu.parseSideMenu(mode, "unit_menu.xml", "");
        metaMgr.closeDataSource();

        /* Add ids for links*/
        if ("Ar".equalsIgnoreCase(mode)) {
            dir = "RTL";
            align = "RIGHT";
        }
        String link = "";
        Hashtable style = new Hashtable();
        style = (Hashtable) userSideMenuVec.get(0);
        String title = "<p style='font-weight: bold' align=" + align + " dir=" + dir + ">" + (String) style.get("title");
        title += " " + (String) wbo.getAttribute("projectName") + "</p>";
        style.remove("title");
        style.put("title", title);

        Vector menuElement = new Vector();
        for (int i = 1; i < userSideMenuVec.size() - 1; i++) {
            if (i != (userSideMenuVec.size() - 2)) {
                link = "";
                menuElement = (Vector) userSideMenuVec.get(i);
                link = menuElement.get(1).toString();
                link = link.replace("ID", parent).replace("UNIT", Id).replace("NUM", numberOfUsers).replace("INDX", index);
                menuElement.remove(1);
                menuElement.add(link);
            } else {
                link = "";
                menuElement = (Vector) userSideMenuVec.get(i);
                link = menuElement.get(1).toString();
                menuElement.remove(1);
                menuElement.add(link);

            }
        }

        request.getSession().setAttribute("sideMenuVec", userSideMenuVec);
        request.getSession().setAttribute("currentUserID", Id);
        request.getSession().setAttribute("activeClient", userSideMenuVec);
        request.getSession().setAttribute("normalClient", userSideMenuVec);

    }

    public static void createClientSideMenu(String clientID, WebBusinessObject clientWbo, HttpServletRequest request) {
        String dir = "RTL";
        String align = "RIGHT";
        String mode = request.getSession().getAttribute("currentMode").toString();

        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        metaMgr.setMetaData("xfile.jar");
        ParseSideMenu parseSideMenu = new ParseSideMenu();

        Vector userSideMenuVec = parseSideMenu.parseSideMenu(mode, "client_menu.xml", "");
        metaMgr.closeDataSource();

        String link = "";
        Hashtable style = new Hashtable();
        style = (Hashtable) userSideMenuVec.get(0);
        String title = "<p style='font-weight: bold' align=" + align + " dir=" + dir + ">" + (String) style.get("title");
        title += " </p>";
        title += " " + (String) clientWbo.getAttribute("name") + "</p>";
        style.remove("title");
        style.put("title", title);

        Vector menuElement = new Vector();
        for (int i = 1; i < userSideMenuVec.size() - 1; i++) {
            if (i != (userSideMenuVec.size() - 2)) {
                link = "";
                menuElement = (Vector) userSideMenuVec.get(i);
                link = menuElement.get(1).toString();
                link = link.replace("CId", clientID);
                menuElement.remove(1);
                menuElement.add(link);
            } else {
                link = "";
                menuElement = (Vector) userSideMenuVec.get(i);
                link = menuElement.get(1).toString();
                menuElement.remove(1);
                menuElement.add(link);

            }
        }

        request.getSession().setAttribute("sideMenuVec", userSideMenuVec);
        request.getSession().setAttribute("currentUserID", clientID);
        request.getSession().setAttribute("activeClient", userSideMenuVec);
        request.getSession().setAttribute("normalClient", userSideMenuVec);
    }

    public static HSSFWorkbook createExcelReport(String sheetName, String[] headerName, String[] headerValueStr, String[] headers, String[] attributes, String[] attributeType, ArrayList data) {
        WebBusinessObject wbo;
        HSSFWorkbook workBook = new HSSFWorkbook();
        HSSFCellStyle cellStyle = workBook.createCellStyle();
        HSSFSheet sheet = workBook.createSheet(sheetName);
        HSSFFont font = workBook.createFont();
        font.setBoldweight(font.BOLDWEIGHT_BOLD);
        cellStyle.setAlignment(cellStyle.ALIGN_CENTER);
        cellStyle.setFont(font);
        cellStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
        cellStyle.setFillForegroundColor(new HSSFColor.GREY_25_PERCENT().getIndex());

        // for Columns Width
        for (int i = 0; i < attributeType.length; i++) {
            if (attributeType[i].equalsIgnoreCase("String")) {
                sheet.setColumnWidth((short) i, (short) 7000);
            } else {
                sheet.setColumnWidth((short) i, (short) 3000);
            }
        }
        
        // to create the Header
        int headerNameCount = 0;
        HSSFRow tableHeaderRow = null;
        HSSFCell tableHeaderCellT1 = null;
        for (; headerNameCount < headerName.length && headerName[headerNameCount] != null && !headerName[headerNameCount].isEmpty(); headerNameCount++) {
            tableHeaderRow = sheet.createRow((short) headerNameCount);
            tableHeaderCellT1 = tableHeaderRow.createCell((short) 1);
            tableHeaderCellT1.setCellStyle(cellStyle);
            tableHeaderCellT1.setCellValue(headerName[headerNameCount]);
            if(headerValueStr != null){
                tableHeaderCellT1 = tableHeaderRow.createCell((short) 2);
                tableHeaderCellT1.setCellStyle(cellStyle);
                tableHeaderCellT1.setCellValue(headerValueStr[headerNameCount]);
            }
            HSSFCellUtil.setAlignment(tableHeaderCellT1, workBook, HSSFCellStyle.ALIGN_CENTER);
            sheet.addMergedRegion(new Region(headerNameCount, (short) 2, headerNameCount, (short) 4));
        }

        headerNameCount++;
        // to create the Report Date
        tableHeaderRow = sheet.createRow((short) headerNameCount);
        tableHeaderCellT1 = tableHeaderRow.createCell((short) 1);
        tableHeaderCellT1.setCellStyle(cellStyle);
        tableHeaderCellT1.setCellValue("Report Date :");
        tableHeaderCellT1 = tableHeaderRow.createCell((short) 2);
        tableHeaderCellT1.setCellStyle(cellStyle);
        tableHeaderCellT1.setCellValue(new java.util.Date().toGMTString());
        
        HSSFCellUtil.setAlignment(tableHeaderCellT1, workBook, HSSFCellStyle.ALIGN_CENTER);
        sheet.addMergedRegion(new Region(headerNameCount, (short) 2, headerNameCount, (short) 4));

        headerNameCount++;
        // to seperate between the Header and Detail[
        HSSFRow emptyRow = sheet.createRow((short) headerNameCount);

        headerNameCount++;
        // to iterate throw the Headers array
        HSSFRow headerRow = sheet.createRow((short) headerNameCount);
        for (int i = 0; i < headers.length; i++) {
            HSSFCell tableHeaderCell1 = headerRow.createCell((short) i);
            tableHeaderCell1.setCellStyle(cellStyle);
            tableHeaderCell1.setCellValue(headers[i]);
        }

        headerNameCount++;
        // to iterate throw The attributes array and get Data from The Vector
        for (int i = 0; i < data.size(); i++) {
            wbo = (WebBusinessObject) data.get(i);
            HSSFRow row = sheet.createRow(i + headerNameCount);

            for (int j = 0; j < attributes.length; j++) {
                HSSFCell cell = row.createCell((short) j);
                if (attributeType[j].equalsIgnoreCase("Number")) {
                    cell.setCellValue(new Double(wbo.getAttribute(attributes[j]).toString()).doubleValue());
                } else if (attributeType[j].equalsIgnoreCase("Formula")) {
                    cell.setCellFormula(wbo.getAttribute(attributes[j]).toString());
                } else {
                    if (wbo.getAttribute(attributes[j]) != null) {
                        cell.setCellValue(wbo.getAttribute(attributes[j]).toString());
                    } else if("Number".equals(attributes[j])) {
                        cell.setCellValue(i + 1);
                    }
                }
                HSSFCellUtil.setAlignment(cell, workBook, HSSFCellStyle.ALIGN_CENTER);
            }
        }
                
        return workBook;
    }

    public static String checkNumber(String text) {
        String value = "ظ„ط§ظٹظˆط¬ط¯";
        text = text.trim();
        if (NumberUtils.isNumber(text)) {
            value = text;
        }
        return value;
    }

    public static String checkLength(String value, int length) {
        if (value != null && value.length() > length) {
            return value.substring(0, length - 3) + "...";
        }
        return value;
    }

    public static void createBuildingUnitSideMenu(String projectId, String parent, String userId, HttpServletRequest request) {
        String dir = "LTR";
        String align = "LEFT";
        ProjectMgr projectMgr = ProjectMgr.getInstance();
        WebBusinessObject wbo = projectMgr.getOnSingleKey(projectId);
        String mode = request.getSession().getAttribute("currentMode").toString();
        /**
         * *********** Side Menu ****************
         */
        //open Jar File
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        metaMgr.setMetaData("xfile.jar");
        ParseSideMenu parseSideMenu = new ParseSideMenu();
        Vector unitSideMenuVec = parseSideMenu.parseSideMenu(mode, "building_unit_menu.xml", "");
        metaMgr.closeDataSource();

        /* Add ids for links*/
        if ("Ar".equalsIgnoreCase(mode)) {
            dir = "RTL";
            align = "RIGHT";
        }
        String link = "";
        Hashtable style = new Hashtable();
        style = (Hashtable) unitSideMenuVec.get(0);
        String title = "<p style='font-weight: bold' align=" + align + " dir=" + dir + ">" + (String) style.get("title");
        title += " " + (String) wbo.getAttribute("projectName") + "</p>";
        style.remove("title");
        style.put("title", title);

        Vector menuElement = new Vector();
        for (int i = 1; i < unitSideMenuVec.size(); i++) {
            if (i == 1) {
                link = "";
                menuElement = (Vector) unitSideMenuVec.get(i);
                link = menuElement.get(1).toString();
                link = link.replace("PROJID", projectId).replace("USERID", userId);
                menuElement.remove(1);
                menuElement.add(link);
            } else {
                link = "";
                menuElement = (Vector) unitSideMenuVec.get(i);
                link = menuElement.get(1).toString();
                menuElement.remove(1);
                menuElement.add(link);
            }
        }

        request.getSession().setAttribute("sideMenuVec", unitSideMenuVec);
        request.getSession().setAttribute("currentUserID", userId);
    }

    public static void createPdfReport(String reportName, ServletContext context, HttpServletResponse response, HttpServletRequest request) throws IOException {
        //set jasper report file name
        String reportFileNameSource = context.getRealPath(getFileSeparator() + "reports" + getFileSeparator() + reportName + ".jrxml");
        String reportFileName = context.getRealPath(getFileSeparator() + "reports" + getFileSeparator() + reportName + ".jasper");

        try {
            // Compile report if needed
            File reportFileSource = new File(reportFileNameSource);
            if (!reportFileSource.exists()) {
                throw new FileNotFoundException(String.valueOf(reportFileSource));
            }

            File reportFile = new File(reportFileName);
            if (!reportFile.exists() || reportFileSource.lastModified() > reportFile.lastModified()) {
                JasperCompileManager.compileReportToFile(reportFileNameSource, reportFileName);
            }

            ServletOutputStream servletOutputStream = response.getOutputStream();
            byte[] bytes;

            bytes = JasperRunManager.runReportToPdf(reportFileName, null);

            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "inline; filename=\"" + reportName.toUpperCase() + ".pdf\"");
            response.setContentLength(bytes.length);
            servletOutputStream.write(bytes, 0, bytes.length);
            servletOutputStream.flush();
            servletOutputStream.close();

        } catch (FileNotFoundException ex) {
            logger.error(ex.getMessage());
        } catch (IOException ex) {
            logger.error(ex.getMessage());
        } catch (JRException ex) {
            logger.error(ex.getMessage());
        }
    }

    public static byte[] generateClientsByEmployeeReport(String groupID, java.sql.Date bDate, java.sql.Date eDate) {
        MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
        UserMgr userMgr = UserMgr.getInstance();
        IssueByComplaintMgr issueByComplaintMgr = IssueByComplaintMgr.getInstance();

        int totalReservation, totalConfirmed;
        Vector<WebBusinessObject> reportData = new Vector();

        try {
            List<WebBusinessObject> usersList = userMgr.getUsersByGroup(groupID);

            for (WebBusinessObject userWbo : usersList) {
                totalReservation = 0;
                totalConfirmed = 0;

                ArrayList<WebBusinessObject> issuesList = issueByComplaintMgr.getComplaintsPerEmployee((String) userWbo.getAttribute("userId"), bDate, eDate, null, null);

                for (WebBusinessObject issueWbo : issuesList) {
                    if (issueWbo.getAttribute("totalConfirmed") != null && !issueWbo.getAttribute("totalConfirmed").equals("0")) {
                        totalConfirmed++;
                    } else if (issueWbo.getAttribute("totalReservation") != null && !issueWbo.getAttribute("totalReservation").equals("0")) {
                        totalReservation++;
                    }
                }

                userWbo.setAttribute("totalReservation", new Integer(totalReservation));
                userWbo.setAttribute("totalConfirmed", new Integer(totalConfirmed));
                userWbo.setAttribute("totalClients", new Integer(issuesList.size()));
                reportData.add(userWbo);
            }

            HashMap parameters = new HashMap();

            // get Logo
            String logoName = (String) metaDataMgr.getLogos().get("headReport3");

            //ReportName
            String reportName = "EmployeeProductivity";

            //Report paths
            String reportFileNameSource = metaDataMgr.getRealRootPath() + "/reports" + getFileSeparator() + reportName + ".jrxml";
            String reportFileName = metaDataMgr.getRealRootPath() + "/reports" + getFileSeparator() + reportName + ".jasper";
            String subReportDir = metaDataMgr.getRealRootPath() + "/reports" + getFileSeparator();
            String logoPath = metaDataMgr.getRealRootPath() + "/images" + getFileSeparator() + logoName;

            //set in parameters
            parameters.put("logo", logoPath);
            parameters.put("SUBREPORT_DIR", subReportDir);
            parameters.put("fromDate", bDate.toString());
            parameters.put("toDate", eDate.toString());

            // Compile report if needed
            File reportFileSource = new File(reportFileNameSource);
            if (!reportFileSource.exists()) {
                throw new FileNotFoundException(String.valueOf(reportFileSource));
            }

            File reportFile = new File(reportFileName);
            JasperCompileManager.compileReportToFile(reportFileNameSource, reportFileName);

            WboCollectionDataSource itrate = new WboCollectionDataSource(reportData);
            byte[] bytes = JasperRunManager.runReportToPdf(reportFileName, parameters, itrate);
            return bytes;
        } catch (Exception ex) {
            System.out.println("ClientsByEmployeeReport Exception = " + ex.getMessage());
        }

        return null;
    }

    public static byte[] generateClientsByEmployeeDetailedReport(String groupID, java.sql.Date bDate, java.sql.Date eDate) {
        MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
        UserMgr userMgr = UserMgr.getInstance();
        IssueByComplaintMgr issueByComplaintMgr = IssueByComplaintMgr.getInstance();

        int totalReservation, totalConfirmed;

        Vector<WebBusinessObject> reportDetails = new Vector();

        try {
            List<WebBusinessObject> usersList = userMgr.getUsersByGroup(groupID);

            for (WebBusinessObject userWbo : usersList) {
                Vector<WebBusinessObject> employeeVec = new Vector();

                totalReservation = 0;
                totalConfirmed = 0;

                ArrayList<WebBusinessObject> issuesList = issueByComplaintMgr.getComplaintsPerEmployee((String) userWbo.getAttribute("userId"), bDate, eDate, null, null);

                for (WebBusinessObject issueWbo : issuesList) {
                    if (issueWbo.getAttribute("totalConfirmed") != null && !issueWbo.getAttribute("totalConfirmed").equals("0")) {
                        totalConfirmed++;
                    } else if (issueWbo.getAttribute("totalReservation") != null && !issueWbo.getAttribute("totalReservation").equals("0")) {
                        totalReservation++;
                    }
                }

                userWbo.setAttribute("totalReservation", new Integer(totalReservation));
                userWbo.setAttribute("totalConfirmed", new Integer(totalConfirmed));
                userWbo.setAttribute("totalClients", new Integer(issuesList.size()));

                employeeVec.add(userWbo);

                WebBusinessObject tempDetails = new WebBusinessObject();
                tempDetails.setAttribute("employee", employeeVec);
                tempDetails.setAttribute("client", issuesList);
                reportDetails.add(tempDetails);
            }

            HashMap parameters = new HashMap();

            // get Logo
            String logoName = (String) metaDataMgr.getLogos().get("headReport3");

            //ReportName
            String reportName = "EmployeeDetailedProductivity";

            //Report paths
            String reportFileNameSource = metaDataMgr.getRealRootPath() + "/reports" + getFileSeparator() + reportName + ".jrxml";
            String reportFileName = metaDataMgr.getRealRootPath() + "/reports" + getFileSeparator() + reportName + ".jasper";
            String subReportDir = metaDataMgr.getRealRootPath() + "/reports" + getFileSeparator();
            String logoPath = metaDataMgr.getRealRootPath() + "/images" + getFileSeparator() + logoName;

            //set in parameters
            parameters.put("logo", logoPath);
            parameters.put("SUBREPORT_DIR", subReportDir);
            parameters.put("fromDate", bDate.toString());
            parameters.put("toDate", eDate.toString());

            // Compile report if needed
            File reportFileSource = new File(reportFileNameSource);
            if (!reportFileSource.exists()) {
                throw new FileNotFoundException(String.valueOf(reportFileSource));
            }

            File reportFile = new File(reportFileName);
            JasperCompileManager.compileReportToFile(reportFileNameSource, reportFileName);

            WboCollectionDataSource itrate = new WboCollectionDataSource(reportDetails);
            byte[] bytes = JasperRunManager.runReportToPdf(reportFileName, parameters, itrate);
            return bytes;
        } catch (Exception ex) {
            System.out.println("ClientsByEmployeeDetailedReport Exception = " + ex.getMessage());
        }

        return null;
    }

    public static byte[] getClientsCommentsReport(java.sql.Date bDate, java.sql.Date eDate) {
        MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
        CommentsMgr commentsMgr = CommentsMgr.getInstance();

        SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
        String startDate = formatter.format(bDate);
        String endDate = formatter.format(eDate);

        Vector<WebBusinessObject> clients = new Vector<>();
        Vector clientsCommentsPDF = new Vector();
        ArrayList<WebBusinessObject> commentsList = new ArrayList<>();
        Map<String, ArrayList<WebBusinessObject>> dataResult = new HashMap<>();

        try {
            clients = commentsMgr.getClientsComments(startDate, endDate, "", null, null, null, null);

            for (WebBusinessObject clientWbo : clients) {
                try {
                    commentsList = commentsMgr.getClientComments((String) clientWbo.getAttribute("clientID"), "", null);
                    dataResult.put((String) clientWbo.getAttribute("clientID"), commentsList);

                    //Prepare PDF Report Object
                    WebBusinessObject clientWboTemp = new WebBusinessObject();
                    Vector<WebBusinessObject> clientsVec = new Vector();
                    clientsVec.add(clientWbo);
                    clientWboTemp.setAttribute("client", clientsVec);
                    clientWboTemp.setAttribute("comments", commentsList);
                    clientsCommentsPDF.add(clientWboTemp);

                } catch (Exception ex) {
                    java.util.logging.Logger.getLogger(CommentsServlet.class
                            .getName()).log(Level.SEVERE, null, ex);
                }
            }

            HashMap parameters = new HashMap();

            // get Logo
            String logoName = (String) metaDataMgr.getLogos().get("headReport3");

            //ReportName
            String reportName = "ClientsCommentsReport";

            //Report paths
            String reportFileNameSource = metaDataMgr.getRealRootPath() + "/reports" + getFileSeparator() + reportName + ".jrxml";
            String reportFileName = metaDataMgr.getRealRootPath() + "/reports" + getFileSeparator() + reportName + ".jasper";
            String subReportDir = metaDataMgr.getRealRootPath() + "/reports" + getFileSeparator();
            String logoPath = metaDataMgr.getRealRootPath() + "/images" + getFileSeparator() + logoName;

            //set in parameters
            parameters.put("logo", logoPath);
            parameters.put("SUBREPORT_DIR", subReportDir);
            parameters.put("fromDate", bDate.toString());
            parameters.put("toDate", eDate.toString());

            // Compile report if needed
            File reportFileSource = new File(reportFileNameSource);
            if (!reportFileSource.exists()) {
                throw new FileNotFoundException(String.valueOf(reportFileSource));
            }

            File reportFile = new File(reportFileName);
            JasperCompileManager.compileReportToFile(reportFileNameSource, reportFileName);

            WboCollectionDataSource itrate = new WboCollectionDataSource(clientsCommentsPDF);
            byte[] bytes = JasperRunManager.runReportToPdf(reportFileName, parameters, itrate);
            return bytes;
        } catch (Exception ex) {
            System.out.println("ClientsByEmployeeReport Exception = " + ex.getMessage());
        }

        return null;
    }
    
    public static void createPdfReportEmptyThirdComment(String reportName, Map parameters, Collection dataSource, ServletContext context, HttpServletResponse response, HttpServletRequest request, String logoName) throws IOException {

        MetaDataMgr metaMgr = MetaDataMgr.getInstance();

        /*String reportFileNameSource = context.getRealPath("/" + "reports" + getFileSeparator() + reportName + ".jrxml");
         String reportFileName = context.getRealPath("/" + "reports" + getFileSeparator() + reportName + ".jasper");
         String subReportDir = context.getRealPath("/" + "reports") + getFileSeparator();
         String logoPath = context.getRealPath("/" + "images" + getFileSeparator() + logoName);*/
        String reportFileNameSource = context.getRealPath(getFileSeparator() + "reports" + getFileSeparator() + reportName + ".jrxml");
        String reportFileName = context.getRealPath(getFileSeparator() + "reports" + getFileSeparator() + reportName + ".jasper");
        String subReportDir = context.getRealPath(getFileSeparator() + "reports") + getFileSeparator();
        String logoPath = context.getRealPath(getFileSeparator() + "images" + getFileSeparator() + logoName);

        ArrayList<WebBusinessObject> vec = (ArrayList<WebBusinessObject>) dataSource;

        parameters.put("SUBREPORT_DIR", subReportDir);
        parameters.put("logo", logoPath);

        try {
            // Compile report if needed
            File reportFileSource = new File(reportFileNameSource);
            if (!reportFileSource.exists()) {
                throw new FileNotFoundException(String.valueOf(reportFileSource));
            }

            File reportFile = new File(reportFileName);

            JasperCompileManager.compileReportToFile(reportFileNameSource, reportFileName);

            ServletOutputStream servletOutputStream = response.getOutputStream();
            byte[] bytes;

            bytes = JasperRunManager.runReportToPdf(reportFileName, parameters, new WboCollectionDataSource(dataSource));
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "inline; filename=\"" + reportName.toUpperCase() + ".pdf\"");
            response.setContentLength(bytes.length);
            servletOutputStream.write(bytes, 0, bytes.length);
            servletOutputStream.flush();
            servletOutputStream.close();

        } catch (FileNotFoundException ex) {
            logger.error(ex.getMessage());
        } catch (IOException ex) {
            logger.error(ex.getMessage());
        } catch (JRException ex) {
            logger.error(ex.getMessage());
        }
    }
    
    public static void createPdfReportQPMTime(String reportName, Map parameters, Collection dataSource, ServletContext context, HttpServletResponse response, HttpServletRequest request, String logoName) throws IOException {

        MetaDataMgr metaMgr = MetaDataMgr.getInstance();

        /*String reportFileNameSource = context.getRealPath("/" + "reports" + getFileSeparator() + reportName + ".jrxml");
         String reportFileName = context.getRealPath("/" + "reports" + getFileSeparator() + reportName + ".jasper");
         String subReportDir = context.getRealPath("/" + "reports") + getFileSeparator();
         String logoPath = context.getRealPath("/" + "images" + getFileSeparator() + logoName);*/
        String reportFileNameSource = context.getRealPath(getFileSeparator() + "reports" + getFileSeparator() + reportName + ".jrxml");
        String reportFileName = context.getRealPath(getFileSeparator() + "reports" + getFileSeparator() + reportName + ".jasper");
        String subReportDir = context.getRealPath(getFileSeparator() + "reports") + getFileSeparator();
        String logoPath = context.getRealPath(getFileSeparator() + "images" + getFileSeparator() + logoName);

        Vector<WebBusinessObject> vec = (Vector<WebBusinessObject>) dataSource;

        parameters.put("SUBREPORT_DIR", subReportDir);
        parameters.put("logo", logoPath);

        try {
            // Compile report if needed
            File reportFileSource = new File(reportFileNameSource);
            if (!reportFileSource.exists()) {
                throw new FileNotFoundException(String.valueOf(reportFileSource));
            }

            File reportFile = new File(reportFileName);

            JasperCompileManager.compileReportToFile(reportFileNameSource, reportFileName);

            ServletOutputStream servletOutputStream = response.getOutputStream();
            byte[] bytes;

            bytes = JasperRunManager.runReportToPdf(reportFileName, parameters, new WboCollectionDataSource(dataSource));
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "inline; filename=\"" + reportName.toUpperCase() + ".pdf\"");
            response.setContentLength(bytes.length);
            servletOutputStream.write(bytes, 0, bytes.length);
            servletOutputStream.flush();
            servletOutputStream.close();

        } catch (FileNotFoundException ex) {
            logger.error(ex.getMessage());
        } catch (IOException ex) {
            logger.error(ex.getMessage());
        } catch (JRException ex) {
            logger.error(ex.getMessage());
        }
    }
    
    public static ArrayList<LiteWebBusinessObject> createWboForEmployeeLoginFromExcel(InputStream file, String userID) {
        ArrayList<LiteWebBusinessObject> list = new ArrayList<>();
        try {
            XSSFWorkbook workbook = new XSSFWorkbook(file);

            //Get first sheet from the workbook
            XSSFSheet sheet = workbook.getSheetAt(0);
            Iterator<Row> rowIterator = sheet.iterator();
            if (rowIterator.hasNext()) {
                rowIterator.next(); //First row contains titles
            }
            SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy HH:mm");
            LiteWebBusinessObject wbo;
            String date;
            int index = 0;
            while (rowIterator.hasNext()) {
                System.out.println("index ----------------------------->>> " + index++);
                wbo = new LiteWebBusinessObject();
                Row row = rowIterator.next();
                Cell cell = row.getCell(0);
                wbo.setAttribute("employeeNo", cell != null && Cell.CELL_TYPE_STRING == cell.getCellType() ? cell.getStringCellValue() : "");
                cell = row.getCell(1);
                wbo.setAttribute("employeeName", cell != null && Cell.CELL_TYPE_STRING == cell.getCellType() ? cell.getStringCellValue() : "");
                cell = row.getCell(2);
                date = cell != null && Cell.CELL_TYPE_STRING == cell.getCellType() ? cell.getStringCellValue() : "";
                cell = row.getCell(4);
                try {
                    wbo.setAttribute("loginDate", cell != null && !date.isEmpty() && Cell.CELL_TYPE_STRING == cell.getCellType() && cell.getStringCellValue() != null && !cell.getStringCellValue().isEmpty() ? new Timestamp(sdf.parse(date + " " + cell.getStringCellValue()).getTime()) : "");
                } catch (ParseException ex) {
                    wbo.setAttribute("loginDate", "");
                }
                cell = row.getCell(5);
                try {
                    wbo.setAttribute("logoutDate", cell != null && !date.isEmpty() && Cell.CELL_TYPE_STRING == cell.getCellType() && cell.getStringCellValue() != null && !cell.getStringCellValue().isEmpty() ? new Timestamp(sdf.parse(date + " " + cell.getStringCellValue()).getTime()) : "");
                } catch (ParseException ex) {
                    wbo.setAttribute("logoutDate", "");
                }
                cell = row.getCell(3);
                wbo.setAttribute("timeTable", cell != null && Cell.CELL_TYPE_STRING == cell.getCellType() ? cell.getStringCellValue() : "");
                wbo.setAttribute("userID", userID);
                wbo.setAttribute("option1", "UL");
                wbo.setAttribute("option2", "UL");
                wbo.setAttribute("option3", "UL");
                wbo.setAttribute("option4", "UL");
                wbo.setAttribute("option5", "UL");
                wbo.setAttribute("option6", "UL");
                list.add(wbo);
            }
        } catch (IOException ex) {
            java.util.logging.Logger.getLogger(Tools.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }
    
     public void showReport(String reportName, Map parameters, Connection conn, ServletContext context, HttpServletResponse response, HttpServletRequest request,String reportType) {
        IssueMgr issueMgr =  IssueMgr.getInstance();
         ReportConfigUtil reportConfigUtil = new ReportConfigUtil();
        String lang = "E";
        String compileDir = context.getRealPath(getFileSeparator() + "reports") + getFileSeparator();
        compileDir = compileDir.replace("\\","/");
        try {
           parameters.put("SUBREPORT_DIR", compileDir);
           reportConfigUtil.compileReport(context, compileDir, reportName);
           File reportFile = new File(compileDir + reportName + ".jasper");
           
           /////////////////////
//           parameters.put(JRXlsAbstractExporter.PROPERTY_SHEET_DIRECTION, "RTL");
           JasperPrint jasperPrint = reportConfigUtil.fillReport(reportFile, parameters, conn);
//           jasperPrint.setOrientation(OrientationEnum.PORTRAIT);
//           HttpServletResponse httpServletResponse = (HttpServletResponse) FacesContext.getCurrentInstance().getExternalContext().getResponse();
           ServletOutputStream servletOutputStream = response.getOutputStream();
//           if(lang!=null && !lang.equals("") && lang.equals("A")){
//               reportConfigUtil.mirrorLayout(jasperPrint);
//           }
           
           if(reportType.equals("PDF")){
            byte[] bytes = JasperRunManager.runReportToPdf(reportFile.getPath(), parameters, conn);
            response.setContentType("application/pdf");
            response.setContentLength(bytes.length);
            ServletOutputStream outStream = response.getOutputStream();
            outStream.write(bytes, 0, bytes.length);
            outStream.flush();
            outStream.close();
               JasperExportManager.exportReportToPdfStream(jasperPrint, servletOutputStream);
           }else if(reportType.equals("Excel")){
//               jasperPrint = reportConfigUtil.fillReport(reportFile, parameters, conn);
//               ReportConfigUtil.exportReportAsExcel(jasperPrint, httpServletResponse.getWriter());
//               HttpServletResponse httpServletResponse1 = (HttpServletResponse) FacesContext.getCurrentInstance().getExternalContext().getResponse();
               response.addHeader("Content-disposition", "attachment; filename="+reportName+".xlsx");
               ServletOutputStream servletOutputStream1 = response.getOutputStream();
               JRXlsxExporter docxExporter = new JRXlsxExporter();
               docxExporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
               docxExporter.setParameter(JRExporterParameter.OUTPUT_STREAM, servletOutputStream1);
               docxExporter.exportReport();
           }
        
        } catch (IOException ex) {
            java.util.logging.Logger.getLogger(Tools.class.getName()).log(Level.SEVERE, null, ex);
        } catch (JRException ex) {
            java.util.logging.Logger.getLogger(Tools.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}