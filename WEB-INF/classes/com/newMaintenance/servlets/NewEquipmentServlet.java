package com.newMaintenance.servlets;

import com.contractor.db_access.MaintainableMgr;
import com.docviewer.servlets.DocViewerFileRenamePolicy;
import com.maintenance.common.DateParser;
import com.maintenance.common.ParseSideMenu;
import com.maintenance.db_access.CategoryMgr;
import com.maintenance.db_access.ConfigureMainTypeMgr;
import com.maintenance.db_access.DelayReasonsMgr;
import com.maintenance.db_access.EmpBasicMgr;
import com.businessfw.hrs.db_access.EmployeeMgr;
import com.maintenance.db_access.EqChangesMgr;
import com.maintenance.db_access.EquipOperationMgr;
import com.maintenance.db_access.EquipmentMaintenanceMgr;
import com.maintenance.db_access.EquipmentStatusMgr;
import com.maintenance.db_access.EquipmentSuppliersMgr;
import com.maintenance.db_access.IssueTasksMgr;
import com.maintenance.db_access.ItemsMgr;
import com.maintenance.db_access.LocalStoresItemsMgr;
import com.maintenance.db_access.MainCategoryTypeMgr;
import com.maintenance.db_access.MaintenanceItemMgr;
import com.maintenance.db_access.ParentUnitMgr;
import com.maintenance.db_access.ProductionLineMgr;
import com.maintenance.db_access.QuantifiedMntenceMgr;
import com.maintenance.db_access.ScheduleMgr;
import com.maintenance.db_access.ScheduleTasksMgr;
import com.maintenance.db_access.SupplementMgr;
import com.maintenance.db_access.SupplierEquipmentMgr;
import com.maintenance.db_access.TaskMgr;
import com.maintenance.db_access.UnitDocMgr;
import com.maintenance.db_access.FixedAssetsMachineMgr;
import com.maintenance.db_access.SupplierMgr;
import com.maintenance.db_access.UnitScheduleMgr;
import com.silkworm.Exceptions.IncorrectFileType;
import com.silkworm.Exceptions.NoUserInSessionException;
import com.maintenance.db_access.AverageUnitMgr;
import com.maintenance.db_access.ReadingRateUnitMgr;

import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.common.MetaDataMgr;
import com.silkworm.db_access.FileMgr;
import com.silkworm.jsptags.DropdownDate;
import com.silkworm.persistence.relational.Row;
import com.silkworm.persistence.relational.UniqueIDGen;
import com.silkworm.servlets.MultipartRequest;
import com.silkworm.util.FileIO;
//import com.tracker.business_objects.ExcelCreator;
import com.maintenance.common.AppConstants;
import com.maintenance.common.Tools;
import com.maintenance.db_access.TransactionDetailsMgr;
import com.SpareParts.db_access.TransactionMgr;
import com.android.business_objects.LiteWebBusinessObject;
import com.maintenance.db_access.TransactionStatusMgr;
import com.maintenance.db_access.UserProjectsMgr;
import com.maintenance.servlets.ComplexIssueServlet;
import com.silkworm.common.SecurityUser;
import com.silkworm.logger.db_access.LoggerMgr;
import com.silkworm.pagination.FilterCondition;
import com.silkworm.pagination.Operations;
import com.silkworm.project_doc.SelfDocMgr;
import com.tracker.db_access.DepartmentMgr;
import com.tracker.db_access.EqpSequenceMgr;
import com.tracker.db_access.IssueMgr;
import com.tracker.db_access.ProjectMgr;
import com.tracker.servlets.TrackerBaseServlet;
import java.awt.image.BufferedImage;
import java.io.*;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Hashtable;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.imageio.ImageIO;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


import javax.servlet.*;
import javax.servlet.http.*;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;

public class NewEquipmentServlet extends TrackerBaseServlet {

    SupplierEquipmentMgr supEquipMgr = SupplierEquipmentMgr.getInstance();
    FixedAssetsMachineMgr fixedAssetsMachineMgr = FixedAssetsMachineMgr.getInstance();
    UnitDocMgr unitDocMgr = UnitDocMgr.getInstance();
    MaintainableMgr maintainableMgr = MaintainableMgr.getInstance();
    AverageUnitMgr averageUnitMgr = AverageUnitMgr.getInstance();
    ReadingRateUnitMgr readingRateUnitMgr = ReadingRateUnitMgr.getInstance();
    LoggerMgr loggerMgr = LoggerMgr.getInstance();
    WebBusinessObject loggerWbo = new WebBusinessObject();
    ParentUnitMgr parentUnitMgr = ParentUnitMgr.getInstance();
    UserProjectsMgr userProjectsMgr = UserProjectsMgr.getInstance();
    protected MultipartRequest mpr = null;
    String RIPath = null;
    String absPath = null;
    File docImage = null;
    BufferedInputStream gifData = null;
    BufferedImage myImage = null;
    String imageDirPath = null;
    String pIndex = null;
    long s1, s2;
    long id1;
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    ParseSideMenu parseSideMenu = new ParseSideMenu();
    String equipBase = "";
    EqpSequenceMgr eqpSequenceMgr = EqpSequenceMgr.getInstance();
    DropdownDate dropdownDate = new DropdownDate();
    EmpBasicMgr empBasicMgr = EmpBasicMgr.getInstance();
    DateParser dateParser = new DateParser();
//    private ExcelCreator excelCreator;
    private HSSFWorkbook workBook;
    long id2;

    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }

    public void destroy() {
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            super.processRequest(request, response);
            HttpSession session = request.getSession();
            WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
            SecurityUser securityUser = new SecurityUser();
            securityUser = (SecurityUser) session.getAttribute("securityUser");
            ArrayList tempList = new ArrayList();
            ArrayList categoryList = new ArrayList();

            switch (operation) {
                case 1:
                    maintainableMgr = MaintainableMgr.getInstance();
                    Vector categoryTemp = maintainableMgr.getAllParentSortingById();
                    Vector category = new Vector();

                    servedPage = "/docs/newEquipment/new_equipment_category.jsp";
                    request.setAttribute("data", categoryTemp);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 2:
                    servedPage = "/docs/newEquipment/new_equipment_category.jsp";

                    maintainableMgr = MaintainableMgr.getInstance();
                    Calendar c = Calendar.getInstance();
                    WebBusinessObject wbo = null;
                    Hashtable ht = new Hashtable();

                    String mainCat = (String) request.getParameter("mainCategory");

                    long now = timenow();
                    String flag = "parent";

                    wbo = null;
                    ht = new Hashtable();
                    String unitID = UniqueIDGen.getNextID();
                    //maintenable unit data
                    ht.put("id", unitID);
                    ht.put("parentId", "0");
                    ht.put("unitLevel", "0");
                    ht.put("unitNo", unitID);
                    ht.put("engineNo", "0");
                    ht.put("modelNo", "NON");
                    ht.put("serialNo", "NON");
                    ht.put("unitName", request.getParameter("fullName"));
                    ht.put("manufacturer", "NON");
                    ht.put("location", request.getParameter("locations"));
                    ht.put("dept", request.getParameter("depts"));
                    ht.put("status", "NON");
                    ht.put("empID", request.getParameter("AuthEmp"));
                    ht.put("isMaintainable", new Integer(0));
                    ht.put("noOfHours", new Integer(0));
                    ht.put("desc", request.getParameter("catDescription"));
                    ht.put("rateType", "NON");
                    ht.put("opType", "0");
                    ht.put("mainCat", mainCat);



                    //supplier equipment data
//                    ht.put("supplierID", request.getParameter("supplier"));
                    ht.put("equipID", unitID);
//                    ht.put("purchaseDate", new java.sql.Date(c.getTimeInMillis()));
//                    ht.put("purchasePrice", new Float(0.0));
//                    ht.put("currentValue", new Float(0.0));
//                    ht.put("displosedDate", new java.sql.Date(c.getTimeInMillis()));
//                    ht.put("contractorEmp", request.getParameter("AuthEmp"));
//                    // number 4 mean this is category and didn't has warranty
//                    ht.put("warranty", "4");
//                    ht.put("warrantyDate", new java.sql.Date(c.getTimeInMillis()));
//                    ht.put("notes", "NON");

                    //Equipment Operation Data
                    ht.put("opeartionType", "NON");
                    ht.put("average", new Integer(0));
                    if (request.getParameter("checkIsStandalone") == null) {
                        ht.put("isStandalone", "0");
                    } else {
                        ht.put("isStandalone", "1");
                    }
                    try {
                        if (!maintainableMgr.getDoubleName(request.getParameter("fullName"))) {
                            if (maintainableMgr.saveNewObject3(new WebBusinessObject(ht), now, flag)) {
                                parentUnitMgr.cashData();

                                request.setAttribute("Status", "Ok");
                            } else {
                                request.setAttribute("Status", "No");
                            }
                        } else {
                            request.setAttribute("Status", "No");
                            request.setAttribute("name", "Duplicate Name");
                        }
                    } catch (NoUserInSessionException ex) {
                        logger.error(ex.getMessage());
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }

                    maintainableMgr = MaintainableMgr.getInstance();
                    categoryTemp = maintainableMgr.getAllParentSortingById();
//                    categoryTemp = maintainableMgr.getOnArbitraryDoubleKey("1","key3","0","key5");
//                    category = new Vector();
//                    for (int i = 0; i < categoryTemp.size(); i++) {
//                        wbo = (WebBusinessObject) categoryTemp.get(i);
//                        if (wbo.getAttribute("isMaintainable").toString().equalsIgnoreCase("0")) {
//                            category.add(wbo);
//                        }
//                    }
                    request.setAttribute("data", categoryTemp);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
//                case 3:
//                    EmpBasicMgr empBasicMgr = EmpBasicMgr.getInstance();
//
//                    //open Jar File
//                    MetaDataMgr metaMgr=MetaDataMgr.getInstance();
//                    metaMgr.setMetaData("xfile.jar");
//                    ParseSideMenu parseSideMenu=new ParseSideMenu();
//                    Hashtable pages=new Hashtable();
//                    pages=parseSideMenu.getCompanyPages();
//                    metaMgr.closeDataSource();
//
//                    servedPage = pages.get("equipmentPage").toString();
//
//                    String equipBase = request.getParameter("base");
//
//                    maintainableMgr = MaintainableMgr.getInstance();
//                    // tempList = maintainableMgr.getCashedTableAsBusObjects();
//                    categoryList = new ArrayList();
//                    maintainableMgr.executeProcedureMachine("txt");
//                    fixedAssetsMachineMgr.cashData();
//                    categoryTemp=new Vector();
////                    categoryList=parentUnitMgr.getCashedTableAsBusObjects();
//                    categoryTemp = maintainableMgr.getOnArbitraryKey("0","key3");
//                    categoryList = new ArrayList();
//                    for (int i = 0; i < categoryTemp.size(); i++) {
//                        wbo = (WebBusinessObject) categoryTemp.get(i);
//                        if (wbo.getAttribute("isMaintainable").toString().equalsIgnoreCase("0")) {
//                            wbo.setAttribute("parentName",wbo.getAttribute("unitName").toString());
//                            wbo.setAttribute("parentId",wbo.getAttribute("id").toString());
//                            categoryList.add(wbo);
//                        }
//                    }
//
//
//
////                    if (equipBase.equalsIgnoreCase("category")) {
////                        for (int i = 0; i < tempList.size(); i++) {
////                            wbo = (WebBusinessObject) tempList.get(i);
////                            if (wbo.getAttribute("isMaintainable").toString().equalsIgnoreCase("0")) {
////                                categoryList.add(wbo);
////                            }
////                        }
////                    } else if (equipBase.equalsIgnoreCase("equipment")) {
////                        for (int i = 0; i < tempList.size(); i++) {
////                            wbo = (WebBusinessObject) tempList.get(i);
////                            if (wbo.getAttribute("isMaintainable").toString().equalsIgnoreCase("1")) {
////                                categoryList.add(wbo);
////                            }
////                        }
////                    }
//                    request.setAttribute("listWorkers", empBasicMgr.getCashedTableAsBusObjects());
//                    request.setAttribute("base", equipBase);
//                    request.setAttribute("categoryList", categoryList);
//                    request.setAttribute("page", servedPage);
//                    this.forwardToServedPage(request, response);
//                    break;
//                case 4:
//                    String erpFlag = null;
//                    EmpBasicMgr empBasicMgr = EmpBasicMgr.getInstance();
//                    loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
//                    String userId= loggedUser.getAttribute("userId").toString();
//                    String userHome = (String) loggedUser.getAttribute("userHome");
//                    String imageDirPath = getServletContext().getRealPath("/images");
//                    String userImageDir = imageDirPath + "/" + userHome;
//                    String randome = UniqueIDGen.getNextID();
//                    int len = randome.length();
//                    String randFileName = new String("ran" + randome.substring(5, len) + ".jpeg");
//                    String RIPath = userImageDir + "/" + randFileName;
//                    userHome = (String) loggedUser.getAttribute("userHome");
//                    userImageDir = imageDirPath + "/" + userHome;
//                    String userBackendHome = web_inf_path + "/usr/" + userHome + "/";
//                    File usrDir = new File(userBackendHome);
//                    String[] usrDirContents = usrDir.list();
//                    DocViewerFileRenamePolicy ourPolicy = new DocViewerFileRenamePolicy();
//
//                    flag = "equip";
//                    now = timenow();
//                    ourPolicy.setDesiredFileExt("jpg");
//
//                    File oldFile = new File(userBackendHome + ourPolicy.getFileName());
//                    oldFile.delete();
//
//                    try {
//                        mpr = new MultipartRequest(request, userBackendHome, 5 * 1024 * 1024, "UTF-8", ourPolicy);
//                    } catch (IncorrectFileType e) {
//                    }
//                    String fixedMachineNo = maintainableMgr.getFixedMachineNo(mpr.getParameter("equipmentName"));
//                    String averageReading = maintainableMgr.getFixedMachineNo(mpr.getParameter("averageReading"));
//
//                    String fileExtension = mpr.getParameter("fileExtension");
//                    FileMgr fileMgr = FileMgr.getInstance();
//                    WebBusinessObject fileDescriptor = fileMgr.getObjectFromCash(fileExtension);
//                    String metaType = (String) fileDescriptor.getAttribute("metaType");
//
//
//                    maintainableMgr = MaintainableMgr.getInstance();
//
//                    DropdownDate dropdownDate = new DropdownDate();
//                    c = Calendar.getInstance();
//
//                    WebBusinessObject parentWbo = (WebBusinessObject) maintainableMgr.getOnSingleKey(mpr.getParameter("parentCategory"));
//                    Integer unitLevel = new Integer(parentWbo.getAttribute("unitLevel").toString());
//
//                    wbo = null;
//                    ht = new Hashtable();
//                    String ID = mpr.getParameter("equipmentID"); //UniqueIDGen.getNextID();
//                    //maintenable unit data
//                    ht.put("id", ID);
//                    ht.put("parentId", mpr.getParameter("parentCategory"));
//                    ht.put("unitLevel", unitLevel);
//
//                    if (mpr.getParameter("equipmentNo").equals("0000")) {
//                        ht.put("unitNo", fixedMachineNo);
//                        erpFlag = "1";
//                    } else {
//                        ht.put("unitNo", mpr.getParameter("equipmentNo"));
//                        erpFlag = "0";
//                    }
//                    if (mpr.getParameter("averageReading").equals("0")) {
//                        ht.put("statusUnit", "0");
//                    } else {
//                        ht.put("statusUnit", "1");
//                    }
//                    WebBusinessObject wboEmp = empBasicMgr.getOnSingleKey(mpr.getParameter("AuthEmp").toString());
//                    String empName = wboEmp.getAttribute("empName").toString();
//
//                    ht.put("averageReading", mpr.getParameter("averageReading"));
//
//                    if(mpr.getParameter("engineNo").equalsIgnoreCase("")||mpr.getParameter("engineNo")==null)
//                        ht.put("engineNo", "&#1575;&#1604;&#1605;&#1587;&#1578;&#1582;&#1583;&#1605; &#1604;&#1605; &#1610;&#1583;&#1582;&#1604; &#1576;&#1610;&#1575;&#1606;&#1575;&#1578;");
//                    else
//                        ht.put("engineNo", mpr.getParameter("engineNo"));
//
//                    if(mpr.getParameter("modelNo").equalsIgnoreCase("")||mpr.getParameter("modelNo")==null)
//                        ht.put("modelNo", "&#1575;&#1604;&#1605;&#1587;&#1578;&#1582;&#1583;&#1605; &#1604;&#1605; &#1610;&#1583;&#1582;&#1604; &#1576;&#1610;&#1575;&#1606;&#1575;&#1578;");
//                    else
//                        ht.put("modelNo", mpr.getParameter("modelNo"));
//
//                    if(mpr.getParameter("serialNo").equalsIgnoreCase("")||mpr.getParameter("serialNo")==null)
//                        ht.put("serialNo", "&#1575;&#1604;&#1605;&#1587;&#1578;&#1582;&#1583;&#1605; &#1604;&#1605; &#1610;&#1583;&#1582;&#1604; &#1576;&#1610;&#1575;&#1606;&#1575;&#1578;");
//                    else
//                        ht.put("serialNo", mpr.getParameter("serialNo"));
//
//                    ht.put("unitName", mpr.getParameter("equipmentName"));
//
//                    if(mpr.getParameter("manufacturer").equalsIgnoreCase("")||mpr.getParameter("manufacturer")==null)
//                        ht.put("manufacturer", "&#1575;&#1604;&#1605;&#1587;&#1578;&#1582;&#1583;&#1605; &#1604;&#1605; &#1610;&#1583;&#1582;&#1604; &#1576;&#1610;&#1575;&#1606;&#1575;&#1578;");
//                    else
//                        ht.put("manufacturer", mpr.getParameter("manufacturer"));
//
//                    ht.put("location", mpr.getParameter("locations"));
//                    ht.put("dept", mpr.getParameter("depts"));
//                    ht.put("status", mpr.getParameter("status"));
//                    ht.put("empID", mpr.getParameter("AuthEmp"));
//                    ht.put("isMaintainable", new Integer(1));
//                    ht.put("noOfHours", new Integer(0));
//                    ht.put("productionLine", mpr.getParameter("productionLine"));
//                    ht.put("erpFlag", erpFlag);
//                    ht.put("user",userId);
//                    ht.put("empName",empName);
////                    String []serviceDate = mpr.getParameter("serviceEntryDate").split("/");
////                    int eYear=Integer.parseInt(serviceDate[2]);
////                    int eMonth=Integer.parseInt(serviceDate[0]);
////                    int eDay=Integer.parseInt(serviceDate[1]);
////                    java.sql.Date serviceEntryDate=new java.sql.Date(eYear-1900,eMonth-1,eDay);
//
//                    DateParser dateParser=new DateParser();
//                    java.sql.Date serviceEntryDate=dateParser.formatSqlDate(mpr.getParameter("serviceEntryDate"));
//
//                    ht.put("serviceEntryDate",serviceEntryDate);
//
//                    if (mpr.getParameter("checkIsStandalone") == null) {
//                        ht.put("isStandalone", "0");
//                    } else {
//                        ht.put("isStandalone", "1");
//                    }
//
//                    //Handel empty desc
//                    String desc = mpr.getParameter("equipmentDescription");
//                    if (desc.equalsIgnoreCase("") || desc == null) {
//                        ht.put("desc", "No Description");
//                    } else {
//                        ht.put("desc", mpr.getParameter("equipmentDescription"));
//                    }
//
//                    ht.put("rateType", mpr.getParameter("eqptype"));
//                    if (mpr.getParameter("opration").toString().equalsIgnoreCase("Countinous")) {
//                        ht.put("opType", "1");
//                    } else {
//                        ht.put("opType", "2");
//                    }
//
//                    /// Compare date and Time///
//
////                    String acquiringDate = mpr.getParameter("acquiringDate").toString();
////                    String warrantyDate = mpr.getParameter("warrantyDate").toString();
////
////                    String []arrAcquiringDate = acquiringDate.split("/");
////                    int bYear=Integer.parseInt(arrAcquiringDate[2]);
////                    int bMonth=Integer.parseInt(arrAcquiringDate[0]);
////                    int bDay=Integer.parseInt(arrAcquiringDate[1]);
////                    java.sql.Date beginWarraintDate=new java.sql.Date(bYear-1900,bMonth-1,bDay);
////
////                    String []arrWarrantyDate = acquiringDate.split("/");
////                    int eYear=Integer.parseInt(arrWarrantyDate[2]);
////                    int eMonth=Integer.parseInt(arrWarrantyDate[0]);
////                    int eDay=Integer.parseInt(arrWarrantyDate[1]);
////                    java.sql.Date endWarrantyDate=new java.sql.Date(eYear-1900,eMonth-1,eDay);
//
////                    java.sql.Date beginWarraintDate=dateParser.formatSqlDate(acquiringDate);
////                    java.sql.Date endWarrantyDate=dateParser.formatSqlDate(warrantyDate);
//
////                    String acquiringDate = dropdownDate.getDate(mpr.getParameter("acquiringDate")).toString();
////                    String warrantyDate = dropdownDate.getDate(mpr.getParameter("warrantyDate")).toString();
//
////                    DateFormat dateformat = new SimpleDateFormat("yyyy-MM-dd"); // warntyDate = warntyDate.substring(0,4)+warntyDate.substring(5,7)+warntyDate.substring(8,10);
////                    try {
////                        Date acqdate = dateformat.parse(acquiringDate);
////                        Date warrdate = dateformat.parse(warrantyDate);
////                        id1 = acqdate.getTime();
////                        id2 = warrdate.getTime();
////                    } catch (Exception ex) {
////                        logger.error(ex.getMessage());
////                    }
//
//                    //// End Compare //
//                    //supplier equipment data
////                    ht.put("supplierID", mpr.getParameter("supplier"));
//                    ht.put("equipID", ID);
////                    ht.put("purchaseDate", new java.sql.Date(dropdownDate.getDate(mpr.getParameter("acquiringDate")).getTime()));
////                    ht.put("purchasePrice", new Float(mpr.getParameter("price")));
////                    ht.put("currentValue", new Float(mpr.getParameter("currentValue")));
////                    ht.put("displosedDate", new java.sql.Date(dropdownDate.getDate(mpr.getParameter("acquiringDate")).getTime()));
////                    ht.put("contractorEmp", mpr.getParameter("contractor"));
////                    ht.put("warranty", mpr.getParameter("contract"));
////                    ht.put("warrantyDate", endWarrantyDate);
////                    ht.put("warrantyDate", new java.sql.Date(dropdownDate.getDate(mpr.getParameter("warrantyDate")).getTime()));
//
//                    //Handel empty notes
//                    String notes = mpr.getParameter("notes");
//                    if (notes.equalsIgnoreCase("") || notes == null) {
//                        ht.put("notes", "No Notes");
//                    } else {
//                        ht.put("notes", mpr.getParameter("notes"));
//                    }
//                    WebBusinessObject maintainablerecord = maintainableMgr.getOnSingleKey((String)mpr.getParameter("parentCategory"));
//                    ht.put("mainCat",(String)maintainablerecord.getAttribute("maintTypeId"));
//
//                    //Equipment Operation Data
//                    ht.put("opeartionType", mpr.getParameter("opration"));
//                    ht.put("average", new Integer(mpr.getParameter("average")));
//
//                    try {
////                        if (id1 >= id2) {
////                            request.setAttribute("Status", "No");
////                            request.setAttribute("checkdate", "Warranty date not valid");
//                        // } else {
//                        if (!maintainableMgr.getDoubleNameEquip(mpr.getParameter("equipmentName"))) {
//                            if (maintainableMgr.saveNewObject3(new WebBusinessObject(ht), now, flag)) {
//
//                                maintainableMgr.cashData();
//                                request.setAttribute("Status", "Ok");
//                                 maintainableMgr.executeProcedureMachine("txt");
//                                 fixedAssetsMachineMgr.cashData();
//
//                                WebBusinessObject savedObj=maintainableMgr.getOnSingleKey(ht.get("id").toString());
//
//                                /******Create Dynamic contenet of Issue menu *******/
//                                //open Jar File
//                                metaMgr=MetaDataMgr.getInstance();
//                                metaMgr.setMetaData("xfile.jar");
//                                parseSideMenu=new ParseSideMenu();
//                                Vector eqpMenu=new Vector();
//                                String mode=(String)request.getSession().getAttribute("currentMode");
//                                eqpMenu=parseSideMenu.parseSideMenu(mode,"equipment_menu.xml","");
//
//                                metaMgr.closeDataSource();
//
//                                /* Add ids for links*/
//                                Vector linkVec=new Vector();
//                                String link="";
//
//                                Hashtable style=new Hashtable();
//                                style=(Hashtable)eqpMenu.get(0);
//                                String title=style.get("title").toString();
//                                title+="<br>"+savedObj.getAttribute("unitName").toString();
//                                style.remove("title");
//                                style.put("title",title);
//
//                                for(int i=1;i<eqpMenu.size()-1;i++){
//                                    linkVec=new Vector();
//                                    link="";
//                                    linkVec=(Vector)eqpMenu.get(i);
//                                    link=(String)linkVec.get(1);
//
//                                    link+=savedObj.getAttribute("id").toString();
//
//                                    linkVec.remove(1);
//                                    linkVec.add(link);
//                                }
//

//                    Hashtable topMenu=new Hashtable();
//                            Vector tempVec=new Vector();
//                            topMenu=(Hashtable)request.getSession().getAttribute("topMenu");
//
//                            if(topMenu!=null && topMenu.size()>0){
//
//                                /* 1- Get the current Side menu
//                                 * 2- Check Menu Type
//                                 * 3- insert menu object to top menu accordding to it's type
//                                 */
//
//                                Vector menuType=new Vector();
//                                Vector currentSideMenu=(Vector)request.getSession().getAttribute("sideMenuVec");
//                                Vector linkVec=new Vector();
//                                if(currentSideMenu!=null && currentSideMenu.size()>0){
//                                    linkVec=new Vector();
//
//                                    // the element # 1 in menu is to view the object
//                                    linkVec=(Vector)currentSideMenu.get(1);
//
//                                    // size-1 becouse the menu type is the last element in vector
//
//                                    menuType=(Vector)currentSideMenu.get(currentSideMenu.size()-1);
//
//                                    if(menuType!=null && menuType.size()>0){
//                                        topMenu.put((String)menuType.get(1),linkVec);
//                                    }
//
//                                }
//                                request.getSession().setAttribute("topMenu",topMenu);
//                            }

//                                request.getSession().setAttribute("sideMenuVec",eqpMenu);
//                                /*End of Menu*/
//
//                                /****************************************************/
//
//                            } else {
//                                request.setAttribute("Status", "No");
//                            }
//                        } else {
//                            request.setAttribute("Status", "No");
//                            request.setAttribute("name", "Duplicate Name");
//                        }
//                        // }
//                    } catch (NoUserInSessionException ex) {
//                        logger.error(ex.getMessage());
//                        request.setAttribute("Status", ex.getMessage());
//                    } catch (Exception ex) {
//                        logger.error(ex.getMessage());
//                        request.setAttribute("Status", ex.getMessage());
//                    }
//
//                    maintainableMgr = MaintainableMgr.getInstance();
//                    //  tempList = maintainableMgr.getCashedTableAsBusObjects();
//                    categoryList = new ArrayList();
//                    categoryList=parentUnitMgr.getCashedTableAsBusObjects();
//                    equipBase = mpr.getParameter("base");
//
////                    if (equipBase.equalsIgnoreCase("category")) {
////                        for (int i = 0; i < tempList.size(); i++) {
////                            wbo = (WebBusinessObject) tempList.get(i);
////                            if (wbo.getAttribute("isMaintainable").toString().equalsIgnoreCase("0")) {
////                                categoryList.add(wbo);
////                            }
////                        }
////                    } else if (equipBase.equalsIgnoreCase("equipment")) {
////                        for (int i = 0; i < tempList.size(); i++) {
////                            wbo = (WebBusinessObject) tempList.get(i);
////                            if (wbo.getAttribute("isMaintainable").toString().equalsIgnoreCase("1")) {
////                                categoryList.add(wbo);
////                            }
////                        }
////                    }
//                    //
//                    String imageName = mpr.getParameter("imageName");
//                    if (imageName != null) {
//                        File newFile = new File(userBackendHome + ourPolicy.getFileName());
//
//                        if (newFile.exists()) {
//
//                            usrDir = new File(imageName);
//                            usrDirContents = usrDir.list();
//
//                            String docImageFilePath = userBackendHome + ourPolicy.getFileName();
//
//                            FileIO.copyFile(docImageFilePath, userImageDir + "\\" + ourPolicy.getFileName());
//
//
//                            String docType = mpr.getParameter("docType");
//                            unitDocMgr.getInstance();
//                            boolean result = unitDocMgr.saveImageDocument(mpr, session, docImageFilePath);
//                        }
//                    }
//                    //
//
//                    request.setAttribute("listWorkers", empBasicMgr.getCashedTableAsBusObjects());
//
//                    request.setAttribute("base", equipBase);
//                    request.setAttribute("categoryList", categoryList);
//                    request.setAttribute("page", servedPage);
//                    this.forwardToServedPage(request, response);
//                    break;
                case 5:
                    maintainableMgr = MaintainableMgr.getInstance();
                    categoryTemp = maintainableMgr.getOnArbitraryKey("0", "key3");
                    category = new Vector();
                    for (int i = 0; i < categoryTemp.size(); i++) {
                        wbo = (WebBusinessObject) categoryTemp.get(i);
                        if (wbo.getAttribute("isMaintainable").toString().equalsIgnoreCase("0")) {
                            category.add(wbo);
                        }
                    }
                    servedPage = "/docs/newEquipment/category_list.jsp";

                    request.setAttribute("data", category);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 6:
                    servedPage = "/docs/newEquipment/view_category.jsp";
                    String categoryID = request.getParameter("categoryID");
                    maintainableMgr = MaintainableMgr.getInstance();
                    WebBusinessObject categoryWBO = maintainableMgr.getOnSingleKey(categoryID);

                    MainCategoryTypeMgr mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();
                    String mainCatId = categoryWBO.getAttribute("maintTypeId").toString();
                    WebBusinessObject mainCatWbo = new WebBusinessObject();
                    mainCatWbo = mainCategoryTypeMgr.getOnSingleKey(mainCatId);
                    if (mainCatWbo != null) {
                        categoryWBO.setAttribute("mainCatName", mainCatWbo.getAttribute("typeName"));
                    } else {
                        categoryWBO.setAttribute("mainCatName", "Main Category Not Found");
                    }

                    request.setAttribute("categoryWBO", categoryWBO);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 7:
                    maintainableMgr = MaintainableMgr.getInstance();
                    tempList = maintainableMgr.getCashedTableAsBusObjects();
                    categoryList = new ArrayList();
                    for (int i = 0; i < tempList.size(); i++) {
                        wbo = (WebBusinessObject) tempList.get(i);
                        if (wbo.getAttribute("isMaintainable").toString().equalsIgnoreCase("0")) {
                            categoryList.add(wbo);
                        }
                    }
                    mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();
                    ArrayList mainTypes = mainCategoryTypeMgr.getCashedTableAsBusObjects();
                    maintainableMgr = MaintainableMgr.getInstance();
                    categoryID = request.getParameter("categoryID");
                    categoryWBO = maintainableMgr.getOnSingleKey(categoryID);

                    mainCatId = categoryWBO.getAttribute("maintTypeId").toString();
                    mainCatWbo = new WebBusinessObject();
                    mainCatWbo = mainCategoryTypeMgr.getOnSingleKey(mainCatId);
                    if (mainCatWbo != null) {
                        categoryWBO.setAttribute("mainCatName", mainCatWbo.getAttribute("typeName"));
                    } else {
                        categoryWBO.setAttribute("mainCatName", "Main Category Not Found");
                    }

                    servedPage = "/docs/newEquipment/update_equipment_category.jsp";
                    request.setAttribute("mainTypes", mainTypes);
                    request.setAttribute("categoryWBO", categoryWBO);
                    request.setAttribute("categoryList", categoryList);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 8:
                    dropdownDate = new DropdownDate();
                    servedPage = "/docs/newEquipment/update_equipment_category.jsp";

                    maintainableMgr = MaintainableMgr.getInstance();
                    c = Calendar.getInstance();
                    wbo = null;
                    ht = new Hashtable();

                    categoryID = request.getParameter("categoryID");
                    ht.put("id", categoryID);

                    //maintenable unit data
                    ht.put("unitName", request.getParameter("catName"));
                    ht.put("mainCategory", request.getParameter("mainCategory"));
                    ht.put("desc", request.getParameter("catDescription"));

                    try {
                        if (maintainableMgr.updateCategoryObject(new WebBusinessObject(ht))) {
                            maintainableMgr.cashData();
                            request.setAttribute("Status", "Ok");
                        } else {
                            request.setAttribute("Status", "No");
                        }
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }

                    maintainableMgr = MaintainableMgr.getInstance();
                    tempList = maintainableMgr.getCashedTableAsBusObjects();
                    categoryList = new ArrayList();
                    for (int i = 0; i < tempList.size(); i++) {
                        wbo = (WebBusinessObject) tempList.get(i);
                        if (wbo.getAttribute("isMaintainable").toString().equalsIgnoreCase("0")) {
                            categoryList.add(wbo);
                        }
                    }
                    mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();
                    mainTypes = mainCategoryTypeMgr.getCashedTableAsBusObjects();

                    categoryWBO = maintainableMgr.getOnSingleKey(categoryID);
                    mainCatId = categoryWBO.getAttribute("maintTypeId").toString();
                    mainCatWbo = new WebBusinessObject();
                    mainCatWbo = mainCategoryTypeMgr.getOnSingleKey(mainCatId);
                    if (mainCatWbo != null) {
                        categoryWBO.setAttribute("mainCatName", mainCatWbo.getAttribute("typeName"));
                    } else {
                        categoryWBO.setAttribute("mainCatName", "Main Category Not Found");
                    }

                    request.setAttribute("mainTypes", mainTypes);
                    request.setAttribute("categoryList", categoryList);
                    request.setAttribute("categoryWBO", categoryWBO);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 9:
                    String categoryName = request.getParameter("categoryName");
                    categoryID = request.getParameter("categoryID");

                    servedPage = "/docs/newEquipment/confirm_delete_category.jsp";
                    request.setAttribute("categoryName", categoryName);
                    request.setAttribute("categoryID", categoryID);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 10:
                    categoryID = request.getParameter("categoryID");
                    categoryName = request.getParameter("categoryName");

                    if (maintainableMgr.deleteCategory(categoryID)) {
                        servedPage = "EquipmentServlet?op=ListCategory";
                    } else {
                        servedPage = "EquipmentServlet?op=confirmDelete&categoryID=" + categoryID + "&categoryName=" + categoryName;
                        request.setAttribute("status", "no");
                    }

                    this.forward(servedPage, request, response);

                    break;
                case 11:
                    int count = 0;
                    loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                    String projectId = loggedUser.getAttribute("projectID").toString();

                    String url = "EquipmentServlet?op=ListEquipment";
                    maintainableMgr = MaintainableMgr.getInstance();
//                    categoryTemp = maintainableMgr.getOnArbitraryDoubleKey("1","key3","0","key5");
                    String[] keyValue = new String[2];
                    String[] keyIndex = new String[2];

                    keyIndex[0] = "key5";
                    keyValue[0] = "0";
                    keyIndex[1] = "key3";
                    keyValue[1] = "1";

                    /******** Distributed Version **********/
//                    categoryTemp =maintainableMgr.getOnArbitraryNumberKey(3,keyValue,keyIndex);
                    /****** Single Version Without any projectId *******/
//                    categoryTemp =maintainableMgr.getOnArbitraryDoubleKey("1","key3","0","key5");
                    categoryTemp = maintainableMgr.getOnArbitraryNumberKeyOrdered(2, keyValue, keyIndex, "key2");

                    String tempcount = (String) request.getParameter("count");
                    if (tempcount != null) {
                        count = Integer.parseInt(tempcount);
                    }

                    category = new Vector();
//                    for (int i = 0; i < categoryTemp.size(); i++) {
//                        wbo = (WebBusinessObject) categoryTemp.get(i);
//                        if (wbo.getAttribute("isMaintainable").toString().equalsIgnoreCase("1") && wbo.getAttribute("isDeleted").toString().equalsIgnoreCase("0")) {
//                            category.add(wbo);
//                        }
//                    }
//                    int index=(count+1)*10;
                    int index = (count + 1) * categoryTemp.size();
                    String id = "";
                    Vector checkattched = new Vector();
                    SupplementMgr supplementMgr = SupplementMgr.getInstance();
                    if (categoryTemp.size() < index) {
                        index = categoryTemp.size();
                    }
                    for (int i = count * 10; i < index; i++) {
                        wbo = (WebBusinessObject) categoryTemp.get(i);
                        id = (String) wbo.getAttribute("id");
                        checkattched = supplementMgr.search(id);
                        if (checkattched.size() > 0) {
                            wbo.setAttribute("nowStatus", "attached");
                        } else {
                            checkattched = supplementMgr.searchAllowedEqps(id);
                            if (checkattched.size() > 0) {
                                wbo.setAttribute("nowStatus", "attached");
                            } else {
                                wbo.setAttribute("nowStatus", "notattached");
                            }
                        }

//              if (wbo.getAttribute("isMaintainable").toString().equalsIgnoreCase("1") && wbo.getAttribute("isDeleted").toString().equalsIgnoreCase("0")) {
                        category.add(wbo);
                        //                  }
                    }

                    float noOfLinks = categoryTemp.size() / 10f;
                    String temp = "" + noOfLinks;
                    int intNo = Integer.parseInt(temp.substring(temp.indexOf(".") + 1, temp.length()));
                    int links = (int) noOfLinks;
                    if (intNo > 0) {
                        links++;
                    }
                    if (links == 1) {
                        links = 0;
                    }

                    session.removeAttribute("CategoryID");
                    servedPage = "/docs/newEquipment/equipment_list.jsp";
                    request.setAttribute("count", "" + count);
                    request.setAttribute("numOfEqps", "" + categoryTemp.size());
                    request.setAttribute("noOfLinks", "" + links);
                    request.setAttribute("fullUrl", url);
                    request.setAttribute("url", url);
                    request.setAttribute("data", category);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 12:
                    servedPage = "/docs/newEquipment/view_equipment.jsp";
                    String equipmentID = request.getParameter("equipmentID");
                    maintainableMgr = MaintainableMgr.getInstance();

                    WebBusinessObject equipmentWBO = maintainableMgr.getOnSingleKey(equipmentID);
                    request.setAttribute("equipmentWBO", equipmentWBO);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 13:
                    ArrayList mainCategoryLists = new ArrayList();
                    ArrayList mainCategory = new ArrayList();
                    String IDd = "";
                    mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();
                    mainCategoryTypeMgr.cashData();
                    categoryList = new ArrayList();
                    mainCategoryLists = mainCategoryTypeMgr.getAllAsArrayList();

                    if (!mainCategoryLists.isEmpty()) {
                        IDd = (String) ((WebBusinessObject) mainCategoryLists.get(0)).getAttribute("id");
                        categoryList = Tools.toArrayList(maintainableMgr.getParentIdAndName(IDd));
                    }

                    equipmentID = request.getParameter("equipmentID");
                    equipmentWBO = maintainableMgr.getOnSingleKey(equipmentID);
                    WebBusinessObject parentWBO = (WebBusinessObject) maintainableMgr.getOnSingleKey(equipmentWBO.getAttribute("parentId").toString());
                    tempList = maintainableMgr.getCashedTableAsBusObjects();


                    servedPage = "/docs/newEquipment/update_equipment.jsp";
                    empBasicMgr = EmpBasicMgr.getInstance();
                    request.setAttribute("listWorkers", empBasicMgr.getCashedTableAsBusObjects());
                    request.setAttribute("mainCategory", mainCategoryLists);
                    request.setAttribute("equipmentWBO", equipmentWBO);
                    request.setAttribute("categoryList", categoryList);
                    //request.setAttribute("page", servedPage);
                    //this.forwardToServedPage(request, response);
                    this.forward(servedPage, request, response);
                    break;
                case 14:

                    servedPage = "/docs/newEquipment/update_equipment.jsp";
                    String eID = (String) request.getParameter("eID");
                    maintainableMgr = MaintainableMgr.getInstance();

                    dropdownDate = new DropdownDate();
                    c = Calendar.getInstance();

                    WebBusinessObject parentWbo = (WebBusinessObject) maintainableMgr.getOnSingleKey(request.getParameter("parentCategory"));

                    wbo = null;
                    ht = new Hashtable();

                    //maintenable unit data
                    ht.put("id", request.getParameter("eID"));
                    ht.put("parentId", request.getParameter("parentCategory"));
                    ht.put("unitLevel", parentWbo.getAttribute("unitLevel").toString());
                    ht.put("unitNo", request.getParameter("equipmentNo"));
                    ht.put("engineNo", request.getParameter("engineNo"));
                    ht.put("modelNo", request.getParameter("modelNo"));
                    ht.put("serialNo", request.getParameter("serialNo"));
                    ht.put("unitName", request.getParameter("equipmentName"));
                    ht.put("manufacturer", request.getParameter("manufacturer"));
                    ht.put("location", request.getParameter("locations"));
                    ht.put("dept", request.getParameter("depts"));
                    ht.put("status", request.getParameter("status"));
                    //ht.put("empID", request.getParameter("AuthEmp"));
                    ht.put("desc", request.getParameter("equipmentDescription"));
                    ht.put("rateType", request.getParameter("eqptype"));
                    ht.put("oldrateType", request.getParameter("oldeqptype"));
                    ht.put("productionLine", request.getParameter("proLine"));
                    if (request.getParameter("opration").toString().equalsIgnoreCase("Continues")) {
                        ht.put("opType", "1");
                    } else {
                        ht.put("opType", "2");
                    }
                    if (request.getParameter("checkIsStandalone") == null) {
                        ht.put("isStandalone", "0");
                    } else {
                        ht.put("isStandalone", "1");
                    }

                    WebBusinessObject maintainablerecord = maintainableMgr.getOnSingleKey((String) request.getParameter("parentCategory"));
                    ht.put("mainCat", (String) maintainablerecord.getAttribute("maintTypeId"));

                    /// Compare date and Time///
//                    acquiringDate = dropdownDate.getDate(request.getParameter("acquiringDate")).toString();
//                    warrantyDate = dropdownDate.getDate(request.getParameter("warrantyDate")).toString();

//                    dateformat = new SimpleDateFormat("yyyy-MM-dd");
//                    try {
//                        Date acqdate = dateformat.parse(acquiringDate);
//                        Date warrdate = dateformat.parse(warrantyDate);
//                        id1 = acqdate.getTime();
//                        id2 = warrdate.getTime();
//                    } catch (Exception ex) {
//                        logger.error(ex.getMessage());
//                    }

                    //supplier equipment data
//                    ht.put("supplierID", request.getParameter("supplier"));
//                    ht.put("purchaseDate", new java.sql.Date(dropdownDate.getDate(request.getParameter("acquiringDate")).getTime()));
//                    ht.put("purchasePrice", new Float(request.getParameter("price")));
//                    ht.put("currentValue", new Float(request.getParameter("currentValue")));
//                    ht.put("displosedDate",  new java.sql.Date(dropdownDate.getDate(request.getParameter("disposedDate")).getTime()));
//                    ht.put("contractorEmp", request.getParameter("contractor"));
//                    ht.put("warranty", request.getParameter("contract"));
//                    ht.put("warrantyDate", new java.sql.Date(dropdownDate.getDate(request.getParameter("warrantyDate")).getTime()));
//                    ht.put("notes", request.getParameter("eqDescription"));
                    ht.put("equipID", request.getParameter("eID"));

                    //Equipment Operation Data
                    ht.put("opeartionType", request.getParameter("opration"));
                    ht.put("average", new Integer(request.getParameter("average")));

                    if (!request.getParameter("eqptype").toString().equals(request.getParameter("oldeqptype").toString())) {
                        try {
                            averageUnitMgr.deleteOnArbitraryKey(request.getParameter("eID").toString(), "key1");
                            readingRateUnitMgr.deleteOnArbitraryKey(request.getParameter("eID").toString(), "key1");
                        } catch (SQLException ex) {
                            logger.error(ex.getMessage());
                        } catch (Exception ex) {
                            logger.error(ex.getMessage());
                        }
                    }

                    try {
//                        if (id1 >= id2) {
//                            request.setAttribute("Status", "No");
//                            request.setAttribute("checkdate", "Warranty date not valid");
//                        } else {
                        if (!maintainableMgr.getDoubleNameforUpdate(eID, request.getParameter("equipmentName"))) {
                            if (maintainableMgr.updateObject(new WebBusinessObject(ht))) {
                                maintainableMgr.cashData();
                                request.setAttribute("Status", "Ok");
                            } else {
                                request.setAttribute("Status", "No");
                            }
                        } else {
                            request.setAttribute("Status", "No");
                            request.setAttribute("name", "Duplicate Name");
                        }
                        //  }
                    } catch (NoUserInSessionException ex) {
                        logger.error(ex.getMessage());
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }


//                } catch (SQLException ex) {
//                    request.setAttribute("Status", new Integer(ex.getErrorCode()).toString());
//                }
                    maintainableMgr = MaintainableMgr.getInstance();
                    tempList = maintainableMgr.getCashedTableAsBusObjects();
                    categoryList = new ArrayList();


                    equipBase = request.getParameter("base");

                    if (parentWbo.getAttribute("isMaintainable").toString().equalsIgnoreCase("0")) {
                        for (int i = 0; i < tempList.size(); i++) {
                            wbo = (WebBusinessObject) tempList.get(i);
                            if (wbo.getAttribute("isMaintainable").toString().equalsIgnoreCase("0")) {
                                categoryList.add(wbo);
                            }
                        }
                    } else if (parentWbo.getAttribute("isMaintainable").toString().equalsIgnoreCase("1")) {
                        for (int i = 0; i < tempList.size(); i++) {
                            wbo = (WebBusinessObject) tempList.get(i);
                            if (wbo.getAttribute("isMaintainable").toString().equalsIgnoreCase("1")) {
                                categoryList.add(wbo);
                            }
                        }
                    }

                    equipmentWBO = maintainableMgr.getOnSingleKey(request.getParameter("eID"));
                    empBasicMgr = EmpBasicMgr.getInstance();
                    request.setAttribute("listWorkers", empBasicMgr.getCashedTableAsBusObjects());

                    request.setAttribute("categoryList", categoryList);
                    request.setAttribute("equipmentWBO", equipmentWBO);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 15:
                    String equipmentName = null;
                    equipmentID = request.getParameter("equipmentID");
                    equipmentWBO = maintainableMgr.getOnSingleKey(equipmentID);
                    equipmentName = (String) equipmentWBO.getAttribute("unitName");

                    servedPage = "/docs/newEquipment/confirm_delequipment.jsp";
                    request.setAttribute("equipmentName", equipmentName);
                    request.setAttribute("equipmentID", equipmentID);
                    request.setAttribute("canDelete", maintainableMgr.canDelete(equipmentID));
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 16:
                    request.getSession().removeAttribute("topMenu");
                    request.getSession().removeAttribute("sideMenuVec");

                    maintainableMgr = MaintainableMgr.getInstance();
                    ScheduleMgr scheduleMgr = ScheduleMgr.getInstance();
                    UnitScheduleMgr unitScheduleMgr = UnitScheduleMgr.getInstance();
                    TransactionMgr transactionMgr = TransactionMgr.getInstance();
                    TransactionDetailsMgr transactionDetailsMgr = TransactionDetailsMgr.getInstance();
                    TransactionStatusMgr transactionStatusMgr = TransactionStatusMgr.getInstance();
                    IssueTasksMgr issueTasksMgr = IssueTasksMgr.getInstance();
                    IssueMgr issueMgr = IssueMgr.getInstance();

                    String issueId;

                    try {
                        Vector issuesVec = issueMgr.getOnArbitraryKey(request.getParameter("equipmentID").toString(), "key6");
                        if (issuesVec.size() > 0) {
                            for (int i = 0; i < issuesVec.size(); i++) {
                                WebBusinessObject issueWbo = (WebBusinessObject) issuesVec.get(i);  // to get equipment issues
                                issueId = issueWbo.getAttribute("id").toString();
                                String ScheduleUnitId = issueMgr.getScheduleUnitId(issueId);        //To delete Schedule Unit

                                if (ScheduleUnitId != null && !ScheduleUnitId.equalsIgnoreCase("")) {
                                    Vector transactionsVec = transactionMgr.getOnArbitraryKey(issueId, "key2");
                                    if (transactionsVec != null && transactionsVec.size() > 0) {  //To delete Transactions
                                        for (int k = 0; k < transactionsVec.size(); k++) {
                                            WebBusinessObject transactionWbo = (WebBusinessObject) transactionsVec.get(i);
                                            transactionMgr.deleteTransactionResult(transactionWbo.getAttribute("transactionNO").toString()); //To delete Transactions Result
                                            transactionStatusMgr.deleteTransactionStatus(transactionWbo.getAttribute("transactionNO").toString()); //To delete Transactions Status

                                            Vector transactionDetailsVec = transactionDetailsMgr.getOnArbitraryKey(transactionWbo.getAttribute("transactionNO").toString(), "key2");
                                            if (transactionDetailsVec != null && transactionDetailsVec.size() > 0) { //To delete Transactions Details
                                                for (int j = 0; j < transactionDetailsVec.size(); j++) {
                                                    WebBusinessObject transactionDetailsWbo = (WebBusinessObject) transactionDetailsVec.get(i);
                                                    transactionDetailsMgr.deleteOnSingleKey(transactionDetailsWbo.getAttribute("id").toString());
                                                }
                                            }
                                            transactionMgr.deleteOnSingleKey(transactionWbo.getAttribute("id").toString());
                                        }
                                    }

                                    unitScheduleMgr.deleteOnSingleKey(ScheduleUnitId);
                                }

                                WebBusinessObject issueTasksWbo = issueTasksMgr.getOnSingleKey1(issueId);
                                if (issueTasksWbo != null) {
                                    issueTasksMgr.deleteOnSingleKey(issueTasksWbo.getAttribute("issueID").toString());
                                }

                                issueMgr.deleteOnSingleKey(issueId);
                            }
                        }

                        Vector scheduleVec = scheduleMgr.getOnArbitraryKey(request.getParameter("equipmentID").toString(), "key2");
                        if (scheduleVec.size() > 0) {
                            for (int i = 0; i < scheduleVec.size(); i++) {
                                WebBusinessObject scheduleWbo = (WebBusinessObject) scheduleVec.get(i);
                                scheduleMgr.deleteOnSingleKey(scheduleWbo.getAttribute("id").toString());
                            }
                        }

                        loggerWbo = new WebBusinessObject();
                        WebBusinessObject objectXml = new WebBusinessObject();
                        objectXml = maintainableMgr.getOnSingleKey(request.getParameter("equipmentID"));
                        loggerWbo.setAttribute("objectXml", objectXml.getObjectAsXML());
                        if (maintainableMgr.deletObject(request.getParameter("equipmentID"))) {
                            loggerWbo.setAttribute("realObjectId", request.getParameter("equipmentID"));
                            loggerWbo.setAttribute("userId", loggedUser.getAttribute("userId"));
                            loggerWbo.setAttribute("objectName", "Equipment");
                            loggerWbo.setAttribute("loggerMessage", "Equipment Deleted");
                            loggerWbo.setAttribute("eventName", "Delete");
                            loggerWbo.setAttribute("objectTypeId", "2");
                            loggerWbo.setAttribute("eventTypeId", "2");
                            loggerMgr.saveObject(loggerWbo);
                        }

                    } catch (SQLException ex) {
                        Logger.getLogger(NewEquipmentServlet.class.getName()).log(Level.SEVERE, null, ex);
                    } catch (Exception ex) {
                        logger.error("Delete Equipment Supplier Exception --> " + ex.getMessage());
                    }
//                maintainableMgr.deleteOnSingleKey(request.getParameter("equipmentID"));

                    String backToUrl = (String) session.getAttribute("lastFilter");
                    if (backToUrl != null && !backToUrl.equalsIgnoreCase("")) {
                        this.forward(backToUrl, request, response);
                    }

                    maintainableMgr.cashData();
                    categoryTemp = maintainableMgr.getOnArbitraryDoubleKey("1", "key3", "0", "key5");
                    category = new Vector();
//                    for (int i = 0; i < categoryTemp.size(); i++) {
//                        wbo = (WebBusinessObject) categoryTemp.get(i);
//                        //                     if (wbo.getAttribute("isMaintainable").toString().equalsIgnoreCase("1") && wbo.getAttribute("isDeleted").toString().equalsIgnoreCase("0")) {
//                        category.add(wbo);
//                        //                     }
//                    }
                    count = 0;
                    tempcount = (String) request.getParameter("count");
                    if (tempcount != null) {
                        count = Integer.parseInt(tempcount);
                    }
//                    index=(count+1)*10;
                    index = (count + 1) * categoryTemp.size();
                    checkattched = new Vector();
                    supplementMgr = SupplementMgr.getInstance();
                    id = "";
                    if (categoryTemp.size() < index) {
                        index = categoryTemp.size();
                    }
                    for (int i = count * 10; i < index; i++) {
                        wbo = (WebBusinessObject) categoryTemp.get(i);
                        id = (String) wbo.getAttribute("id");
                        checkattched = supplementMgr.search(id);
                        if (checkattched.size() > 0) {
                            wbo.setAttribute("nowStatus", "attached");
                        } else {
                            checkattched = supplementMgr.searchAllowedEqps(id);
                            if (checkattched.size() > 0) {
                                wbo.setAttribute("nowStatus", "attached");
                            } else {
                                wbo.setAttribute("nowStatus", "notattached");
                            }
                        }
                        category.add(wbo);
                    }

                    noOfLinks = categoryTemp.size() / 10f;
                    temp = "" + noOfLinks;
                    intNo = Integer.parseInt(temp.substring(temp.indexOf(".") + 1, temp.length()));
                    links = (int) noOfLinks;
                    if (intNo > 0) {
                        links++;
                    }
                    if (links == 1) {
                        links = 0;
                    }

                    servedPage = "/docs/newEquipment/equipment_list.jsp";
//                  request.getSession().setAttribute("isDelete","deleted");
                    request.setAttribute("count", "" + count);
                    request.setAttribute("noOfLinks", "" + links);
                    String tempurl = (String) request.getParameter("url");
                    request.setAttribute("url", tempurl);
                    request.setAttribute("fullUrl", tempurl);
                    request.setAttribute("data", category);

                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);

                    break;
                case 17:
                    servedPage = "/docs/newEquipment/equipment_site_list.jsp";

                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 18:
//                maintainableMgr = MaintainableMgr.getInstance();
//                categoryTemp = maintainableMgr.getOnArbitraryDoubleKey("1","key3","0","key5");
//                category = new Vector();
//                for(int i = 0; i < categoryTemp.size(); i++){
//                    wbo = (WebBusinessObject) categoryTemp.get(i);
//                    if(wbo.getAttribute("isMaintainable").toString().equalsIgnoreCase("1")){
//                        category.add(wbo);
//                    }
//                }
                    if (request.getParameter("categoryID") != null) {
                        categoryID = request.getParameter("categoryID");
                        categoryName = request.getParameter("categoryName");
                        MaintenanceItemMgr maintenanceItemMgr = MaintenanceItemMgr.getInstance();
                        try {
                            Vector items = maintenanceItemMgr.getOnArbitraryKey(categoryID, "key2");
                            request.setAttribute("items", items);
                            request.setAttribute("categoryName", categoryName);
                        } catch (SQLException ex) {
                            logger.error(ex.getMessage());
                        } catch (Exception ex) {
                            logger.error(ex.getMessage());
                        }
                    }
                    servedPage = "/docs/newEquipment/equipment_category.jsp";

//                request.setAttribute("data", category);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 19:
                    servedPage = "/docs/newEquipment/equipment_Tree.jsp";

                    MaintainableMgr maintenableUnit = MaintainableMgr.getInstance();

                    Vector unitsVector = new Vector();
                    try {
                        unitsVector = maintenableUnit.getOnArbitraryKey("0", "key1");
                    } catch (Exception ex) {
                        logger.error("Equipment Tree Exception --> " + ex.getMessage());
                    }

                    request.setAttribute("treeData", unitsVector);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 20:
                    Vector equipments = new Vector();
                    maintenableUnit = MaintainableMgr.getInstance();
                    maintenableUnit.cashData();
//                categoryMgr.cashData();
                    WebBusinessObject userWb0 = (WebBusinessObject) session.getAttribute("loggedUser");
                    equipments = maintenableUnit.getAllCategoryEqu();
//                    equipments = maintenableUnit.getAllCategoryEquBySite(userWb0.getAttribute("projectID").toString());
                    servedPage = "/docs/Adminstration/maintainable_By_Category_List.jsp";

                    request.setAttribute("data", equipments);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 21:
                    count = 0;
                    url = (String) request.getParameter("url");
                    tempcount = (String) request.getParameter("count");
                    if (tempcount != null) {
                        count = Integer.parseInt(tempcount);
                    }

                    maintenableUnit = MaintainableMgr.getInstance();
                    Vector Totalitems = new Vector();
                    category = new Vector();
                    String categoryId = request.getParameter("categoryId");
                    WebBusinessObject eqpWBO = maintainableMgr.getOnSingleKey(categoryId);

                    categoryName = eqpWBO.getAttribute("unitName").toString();
                    session.setAttribute("CategoryID", categoryId);
                    Totalitems = maintenableUnit.getAllEquipment(categoryId);
                    servedPage = "/docs/newEquipment/equipment_list.jsp";

//                    index=(count+1)*10;
                    index = (count + 1) * Totalitems.size();
                    if (Totalitems.size() < index) {
                        index = Totalitems.size();
                    }
                    id = "";
                    checkattched = new Vector();
                    supplementMgr = SupplementMgr.getInstance();
                    for (int i = count * 10; i < index; i++) {
                        wbo = (WebBusinessObject) Totalitems.get(i);
                        id = (String) wbo.getAttribute("id");
                        checkattched = supplementMgr.search(id);
                        if (checkattched.size() > 0) {
                            wbo.setAttribute("nowStatus", "attached");
                        } else {
                            checkattched = supplementMgr.searchAllowedEqps(id);
                            if (checkattched.size() > 0) {
                                wbo.setAttribute("nowStatus", "attached");
                            } else {
                                wbo.setAttribute("nowStatus", "notattached");
                            }
                        }
                        category.add(wbo);
                    }


                    noOfLinks = Totalitems.size() / 10f;
                    temp = "" + noOfLinks;
                    intNo = Integer.parseInt(temp.substring(temp.indexOf(".") + 1, temp.length()));
                    links = (int) noOfLinks;
                    if (intNo > 0) {
                        links++;
                    }
                    if (links == 1) {
                        links = 0;
                    }

                    String lastFilter = "EquipmentServlet?op=ViewUnits&count=0&categoryId=" + categoryId;
                    session.setAttribute("lastFilter", lastFilter);

                    Hashtable topMenu = new Hashtable();
                    Vector tempVec = new Vector();
                    topMenu = (Hashtable) request.getSession().getAttribute("topMenu");
                    if (topMenu != null && topMenu.size() > 0) {
                        tempVec = new Vector();
                        tempVec.add("lastFilter");
                        tempVec.add(lastFilter);
                        topMenu.put("lastFilter", tempVec);
                    } else {
                        topMenu = new Hashtable();
                        topMenu.put("jobOrder", new Vector());
                        topMenu.put("maintItem", new Vector());
                        topMenu.put("schedule", new Vector());
                        topMenu.put("equipment", new Vector());
                        tempVec = new Vector();
                        tempVec.add("lastFilter");
                        tempVec.add(lastFilter);
                        topMenu.put("lastFilter", tempVec);

                    }

                    request.getSession().setAttribute("topMenu", topMenu);

                    String fullUrl = url + "&categoryId=" + categoryId + "&categoryName=" + categoryName;
                    request.setAttribute("count", "" + count);
                    request.setAttribute("noOfLinks", "" + links);
                    request.setAttribute("categoryName", categoryName);
                    request.setAttribute("fullUrl", fullUrl);
                    request.setAttribute("url", url);
                    request.setAttribute("data", category);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 22:
                    servedPage = "/docs/newEquipment/search_equipment.jsp";
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 23:
                    String searchEqNo = request.getParameter("searchEqNo");
                    Vector vecEquipment = new Vector();
                    maintainableMgr = MaintainableMgr.getInstance();
                    if (searchEqNo != null && !searchEqNo.equals("")) {
                        try {
                            vecEquipment = maintainableMgr.getOnArbitraryDoubleKey(searchEqNo, "key4", "0", "key5");
                        } catch (SQLException ex) {
                            servedPage = "/docs/newEquipment/search_equipment.jsp";
                            request.setAttribute("page", servedPage);
                            this.forwardToServedPage(request, response);
                            break;
                        } catch (Exception ex) {
                            logger.error(ex.getMessage());
                            servedPage = "/docs/newEquipment/search_equipment.jsp";
                            request.setAttribute("page", servedPage);
                            this.forwardToServedPage(request, response);
                            break;
                        }
                        if (vecEquipment.size() > 0) {
                            WebBusinessObject wboEquipment = (WebBusinessObject) vecEquipment.elementAt(0);
                            servedPage = "/docs/newEquipment/search_result.jsp";
                            request.setAttribute("equipmentID", wboEquipment.getAttribute("id").toString());
                            request.setAttribute("page", servedPage);
                            this.forwardToServedPage(request, response);
                            break;
                        } else {
                            servedPage = "/docs/newEquipment/search_equipment.jsp";
                            request.setAttribute("message", new String("Equipment with this No. (" + searchEqNo + ") not exist"));
                            request.setAttribute("page", servedPage);
                            this.forwardToServedPage(request, response);
                            break;
                        }
                    } else {
                        servedPage = "/docs/newEquipment/search_equipment.jsp";
                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);
                        break;
                    }
                case 24:
                    loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                    unitDocMgr = unitDocMgr.getInstance();
                    Vector imageList = unitDocMgr.getImagesList(request.getParameter("equipmentID"));
                    Vector imagesPath = new Vector();
                    servedPage = "/docs/unit_doc_handling/view_tab.jsp";
                    request.setAttribute("page", servedPage);

                    String randome,
                     randFileName,
                     userHome,
                     userImageDir,
                     userBackendHome;
                    int len = 0;

                    for (int i = 0; i < imageList.size(); i++) {
                        randome = UniqueIDGen.getNextID();
                        len = randome.length();
                        String docID = ((WebBusinessObject) imageList.get(i)).getAttribute("docID").toString();
                        randFileName = new String("ran" + randome.substring(5, len) + ".jpeg");
                        imageDirPath = getServletContext().getRealPath("/images");
                        userHome = (String) loggedUser.getAttribute("userHome");
                        userImageDir = imageDirPath + "/" + userHome;
                        userBackendHome = web_inf_path + "/usr/" + userHome + "/";

                        RIPath = userImageDir + "/" + randFileName;


                        absPath = "images/" + userHome + "/" + randFileName;

                        docImage = new File(RIPath);

                        gifData = new BufferedInputStream(unitDocMgr.getImage(docID));
                        myImage = ImageIO.read(gifData);
                        ImageIO.write(myImage, "jpeg", docImage);
                        imagesPath.add(absPath);
                    }

                    WebBusinessObject tempEqpWbo = new WebBusinessObject();
                    tempEqpWbo = maintainableMgr.getOnSingleKey(request.getParameter("equipmentID").toString());

                    /******Create Dynamic contenet of Issue menu *******/
                    //open Jar File
                    metaMgr = MetaDataMgr.getInstance();
                    metaMgr.setMetaData("xfile.jar");
                    parseSideMenu = new ParseSideMenu();
                    Vector eqpMenu = new Vector();
                    String mode = (String) request.getSession().getAttribute("currentMode");
                    eqpMenu = parseSideMenu.parseSideMenu(mode, "equipment_menu.xml", "");

                    metaMgr.closeDataSource();

                    /* Add ids for links*/
                    Vector linkVec = new Vector();
                    String link = "";

                    Hashtable style = new Hashtable();
                    style = (Hashtable) eqpMenu.get(0);
                    String title = style.get("title").toString();
                    title += "<br>" + tempEqpWbo.getAttribute("unitName").toString();
                    style.remove("title");
                    style.put("title", title);

                    for (int i = 1; i < eqpMenu.size() - 1; i++) {
                        linkVec = new Vector();
                        link = "";
                        linkVec = (Vector) eqpMenu.get(i);
                        link = (String) linkVec.get(1);

                        link += tempEqpWbo.getAttribute("id").toString();

                        linkVec.remove(1);
                        linkVec.add(link);
                    }

                    topMenu = new Hashtable();
                    tempVec = new Vector();
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

                    request.getSession().setAttribute("sideMenuVec", eqpMenu);
                    /*End of Menu*/

                    /****************************************************/
                    request.setAttribute("equipID", request.getParameter("equipmentID"));
                    request.setAttribute("imagePath", imagesPath);
                    forward("/docs/unit_doc_handling/view_tab.jsp", request, response);

                    break;
                case 25:
                    EquipmentMaintenanceMgr equipmentMaintenanceMgr = EquipmentMaintenanceMgr.getInstance();
                    Vector vecIssues = equipmentMaintenanceMgr.getFutureMaintenace(request.getParameter("equipmentID"));
                    request.setAttribute("vecIssuesFuture", vecIssues);
                    forward("/docs/newEquipment/future_maintenance.jsp", request, response);
                    break;
                case 26:
                    equipmentMaintenanceMgr = EquipmentMaintenanceMgr.getInstance();
                    vecIssues = equipmentMaintenanceMgr.getLastMaintenace(request.getParameter("equipmentID"));
                    request.setAttribute("vecIssuesLast", vecIssues);
                    forward("/docs/newEquipment/last_maintenance.jsp", request, response);
                    break;
                case 27:
                    maintainableMgr = MaintainableMgr.getInstance();
                    String responseString = maintainableMgr.getAllNumbers();
                    if (responseString != null) {
                        response.setContentType("text/xml");
                        response.setHeader("Cache-Control", "no-cache");
                        response.getWriter().write(responseString);
                    } else {
                        // If key comes back as a null, return a question mark.
                        response.setContentType("text/xml");
                        response.setHeader("Cache-Control", "no-cache");
                        response.getWriter().write("?");
                    }
                    break;
                case 28:
                    CategoryMgr categoryMgr = CategoryMgr.getInstance();
                    responseString = categoryMgr.getAllCategoryNames();
                    if (responseString != null) {
                        response.setContentType("text/xml");
                        response.setHeader("Cache-Control", "no-cache");
                        response.getWriter().write(responseString);
                    } else {
                        // If key comes back as a null, return a question mark.
                        response.setContentType("text/xml");
                        response.setHeader("Cache-Control", "no-cache");
                        response.getWriter().write("?");
                    }
                    break;
                case 29:
                    equipmentID = request.getParameter("equipmentID");
                    pIndex = request.getParameter("pIndex");
                    EqChangesMgr eqChangesMgr = EqChangesMgr.getInstance();
                    Vector vecChanges = new Vector();
                    try {
                        vecChanges = eqChangesMgr.getOnArbitraryKey(equipmentID, "key1");
                        int x = vecChanges.size();
                        System.out.println("The pIndex from the servlet is " + pIndex);
                    } catch (Exception e) {
                    }
                    request.setAttribute("data", vecChanges);
                    request.setAttribute("pIndex", pIndex);
                    servedPage = "/docs/newEquipment/new_change.jsp";
                    request.setAttribute("equipmentID", equipmentID);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 30:
                    equipmentID = request.getParameter("equipmentID");

                    servedPage = "/docs/newEquipment/new_change.jsp";
                    eqChangesMgr = EqChangesMgr.getInstance();

                    try {
                        if (eqChangesMgr.saveObject(request, equipmentID)) {
                            request.setAttribute("Status", "OK");
                        } else {
                            request.setAttribute("Status", "No");
                        }
                    } catch (SQLException ex) {
                        request.setAttribute("Status", "No");
                    }
                    vecChanges = new Vector();
                    try {
                        vecChanges = eqChangesMgr.getOnArbitraryKey(equipmentID, "key1");
                    } catch (Exception e) {
                    }
                    request.setAttribute("data", vecChanges);
                    request.setAttribute("equipmentID", equipmentID);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 31:
                    eqChangesMgr = EqChangesMgr.getInstance();
                    equipmentID = request.getParameter("equipmentID");
                    vecChanges = new Vector();
                    try {
                        vecChanges = eqChangesMgr.getOnArbitraryKey(equipmentID, "key1");
                    } catch (Exception e) {
                    }
                    if (request.getParameter("action") != null) {
                        request.setAttribute("action", request.getParameter("action"));
                    }
                    servedPage = "/docs/newEquipment/changes_list.jsp";
                    request.setAttribute("equipmentID", equipmentID);
                    request.setAttribute("data", vecChanges);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 32:
                    equipmentID = request.getParameter("equipmentID");
                    maintainableMgr = MaintainableMgr.getInstance();
                    WebBusinessObject wboEquipment = maintainableMgr.getOnSingleKey(equipmentID);
                    servedPage = "/docs/newEquipment/equipment_job_orders.jsp";
                    request.setAttribute("equipmentID", equipmentID);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 33:
                    loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                    unitDocMgr = unitDocMgr.getInstance();
                    imageList = unitDocMgr.getImagesList(request.getParameter("equipmentID"));
                    imagesPath = new Vector();
                    servedPage = "/docs/unit_doc_handling/view_tab.jsp";
                    request.setAttribute("page", servedPage);
                    filterName = request.getParameter("filterName");
                    filterValue = request.getParameter("filterValue");
                    issueId = request.getParameter("issueId");
                    for (int i = 0; i < imageList.size(); i++) {
                        randome = UniqueIDGen.getNextID();
                        len = randome.length();
                        String docID = ((WebBusinessObject) imageList.get(i)).getAttribute("docID").toString();
                        randFileName = new String("ran" + randome.substring(5, len) + ".jpeg");
                        imageDirPath = getServletContext().getRealPath("/images");
                        userHome = (String) loggedUser.getAttribute("userHome");
                        userImageDir = imageDirPath + "/" + userHome;
                        userBackendHome = web_inf_path + "/usr/" + userHome + "/";

                        RIPath = userImageDir + "/" + randFileName;


                        absPath = "images/" + userHome + "/" + randFileName;

                        docImage = new File(RIPath);

                        gifData = new BufferedInputStream(unitDocMgr.getImage(docID));
                        myImage = ImageIO.read(gifData);
                        ImageIO.write(myImage, "jpeg", docImage);
                        imagesPath.add(absPath);
                    }
                    request.setAttribute("filterName", filterName);
                    request.setAttribute("filterValue", filterValue);
                    request.setAttribute("issueId", issueId);
                    request.setAttribute("equipID", request.getParameter("equipmentID"));
                    request.setAttribute("fromJobOrder", "Yes");
                    request.setAttribute("imagePath", imagesPath);
                    request.setAttribute("backTo", "jobOrder");
                    this.forwardToServedPage(request, response);
                    break;
                case 34:
                    WebBusinessObject userObj = new WebBusinessObject();
                    count = 0;
                    tempcount = (String) request.getParameter("count");
                    if (tempcount != null) {
                        count = Integer.parseInt(tempcount);
                    }

                    maintainableMgr = MaintainableMgr.getInstance();

                    categoryTemp = maintainableMgr.getOnArbitraryDoubleKey("1", "key3", "0", "key5");

//                    session = request.getSession();
                    session = request.getSession();
                    loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                    request.getSession().setAttribute("loggedUser", loggedUser);
//                    WebBusinessObject userObj = (WebBusinessObject) session.getAttribute("loggedUser");
//                    String []params={"1","0",userObj.getAttribute("projectID").toString()};
//                    String []keys={"key3","key5","key11"};
//                    categoryTemp=maintainableMgr.getOnArbitraryNumberKey(3,params,keys);

                    category = new Vector();
//                    for (int i = 0; i < categoryTemp.size(); i++) {
//                        wbo = (WebBusinessObject) categoryTemp.get(i);
//                        if (wbo.getAttribute("isMaintainable").toString().equalsIgnoreCase("1") && wbo.getAttribute("isDeleted").toString().equalsIgnoreCase("0")) {
//                            category.add(wbo);
//                        }
//                    }
                    index = (count + 1) * 30;
//                    index=(count+1)*categoryTemp.size();
                    checkattched = new Vector();
                    supplementMgr = SupplementMgr.getInstance();
                    id = "";
                    if (categoryTemp.size() < index) {
                        index = categoryTemp.size();
                    }
                    for (int i = count * 30; i < index; i++) {
                        wbo = (WebBusinessObject) categoryTemp.get(i);
                        id = (String) wbo.getAttribute("id");
                        checkattched = supplementMgr.search(id);
                        if (checkattched.size() > 0) {
                            wbo.setAttribute("nowStatus", "attached");
                        } else {
                            checkattched = supplementMgr.searchAllowedEqps(id);
                            if (checkattched.size() > 0) {
                                wbo.setAttribute("nowStatus", "attached");
                            } else {
                                wbo.setAttribute("nowStatus", "notattached");
                            }
                        }
                        category.add(wbo);
                    }

                    noOfLinks = categoryTemp.size() / 10f;
                    temp = "" + noOfLinks;
                    intNo = Integer.parseInt(temp.substring(temp.indexOf(".") + 1, temp.length()));
                    links = (int) noOfLinks;
                    if (intNo > 0) {
                        links++;
                    }
                    if (links == 1) {
                        links = 0;
                    }

//                    lastFilter="EquipmentServlet?op=ListInWarranty";
//                    session.setAttribute("lastFilter",lastFilter);
//
//                    topMenu=new Hashtable();
//                    tempVec=new Vector();
//                    topMenu=(Hashtable)request.getSession().getAttribute("topMenu");
//                    if(topMenu!=null && topMenu.size()>0){
//                        tempVec=new Vector();
//                        tempVec.add("lastFilter");
//                        tempVec.add(lastFilter);
//                        topMenu.put("lastFilter",tempVec);
//                    }else{
//                        topMenu=new Hashtable();
//                        topMenu.put("jobOrder",new Vector());
//                        topMenu.put("maintItem",new Vector());
//                        topMenu.put("schedule",new Vector());
//                        topMenu.put("equipment",new Vector());
//                        tempVec=new Vector();
//                        tempVec.add("lastFilter");
//                        tempVec.add(lastFilter);
//                        topMenu.put("lastFilter",tempVec);
//
//                    }

//                    request.getSession().setAttribute("topMenu",topMenu);

//                    session.removeAttribute("CategoryID");
                    servedPage = "/docs/newEquipment/equipment_list_underWarranty.jsp";
                    request.setAttribute("numOfEqps", "" + categoryTemp.size());
                    request.setAttribute("count", "" + count);
                    request.setAttribute("noOfLinks", "" + links);
                    request.setAttribute("data", category);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 35:

                    count = 0;
                    tempcount = (String) request.getParameter("count");
                    if (tempcount != null) {
                        count = Integer.parseInt(tempcount);
                    }

                    maintainableMgr = MaintainableMgr.getInstance();

                    categoryTemp = maintainableMgr.getOnArbitraryDoubleKey("1", "key3", "0", "key5");

                    session = request.getSession();
//                    userObj = (WebBusinessObject) session.getAttribute("loggedUser");
//                    String []params1={"1","0",userObj.getAttribute("projectID").toString()};
//                    String []keys1={"key3","key5","key11"};
//                    categoryTemp=maintainableMgr.getOnArbitraryNumberKey(3,params1,keys1);

                    category = new Vector();

//                    for (int i = 0; i < categoryTemp.size(); i++) {
//                        wbo = (WebBusinessObject) categoryTemp.get(i);
//                        if (wbo.getAttribute("isMaintainable").toString().equalsIgnoreCase("1") && wbo.getAttribute("isDeleted").toString().equalsIgnoreCase("0")) {
//                            category.add(wbo);
//                        }
//                    }
                    checkattched = new Vector();
                    supplementMgr = SupplementMgr.getInstance();
                    id = "";
                    index = (count + 1) * 30;
//                    index=(count+1)*categoryTemp.size();
                    if (categoryTemp.size() < index) {
                        index = categoryTemp.size();
                    }
                    for (int i = count * 30; i < index; i++) {
                        wbo = (WebBusinessObject) categoryTemp.get(i);
                        id = (String) wbo.getAttribute("id");
                        checkattched = supplementMgr.search(id);
                        if (checkattched.size() > 0) {
                            wbo.setAttribute("nowStatus", "attached");
                        } else {
                            checkattched = supplementMgr.searchAllowedEqps(id);
                            if (checkattched.size() > 0) {
                                wbo.setAttribute("nowStatus", "attached");
                            } else {
                                wbo.setAttribute("nowStatus", "notattached");
                            }
                        }
                        category.add(wbo);
                    }

                    noOfLinks = categoryTemp.size() / 10f;
                    temp = "" + noOfLinks;
                    intNo = Integer.parseInt(temp.substring(temp.indexOf(".") + 1, temp.length()));
                    links = (int) noOfLinks;
                    if (intNo > 0) {
                        links++;
                    }
                    if (links == 1) {
                        links = 0;
                    }

                    lastFilter = "EquipmentServlet?op=ListOutWarranty";
                    session.setAttribute("lastFilter", lastFilter);

                    topMenu = new Hashtable();
                    tempVec = new Vector();
                    topMenu = (Hashtable) request.getSession().getAttribute("topMenu");
                    if (topMenu != null && topMenu.size() > 0) {
                        tempVec = new Vector();
                        tempVec.add("lastFilter");
                        tempVec.add(lastFilter);
                        topMenu.put("lastFilter", tempVec);
                    } else {
                        topMenu = new Hashtable();
                        topMenu.put("jobOrder", new Vector());
                        topMenu.put("maintItem", new Vector());
                        topMenu.put("schedule", new Vector());
                        topMenu.put("equipment", new Vector());
                        tempVec = new Vector();
                        tempVec.add("lastFilter");
                        tempVec.add(lastFilter);
                        topMenu.put("lastFilter", tempVec);

                    }

                    request.getSession().setAttribute("topMenu", topMenu);

                    session.removeAttribute("CategoryID");
                    servedPage = "/docs/newEquipment/equipment_list_outWarranty.jsp";
                    request.setAttribute("numOfEqps", "" + categoryTemp.size());
                    request.setAttribute("count", "" + count);
                    request.setAttribute("noOfLinks", "" + links);
                    request.setAttribute("data", category);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 36:
                    servedPage = "/docs/newEquipment/search_equipment_By_Department.jsp";
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 37:
                    String departmentId = request.getParameter("department");
                    url = "EquipmentServlet?op=SearchEquipmentDep&department=" + departmentId;
                    count = 0;
                    tempcount = (String) request.getParameter("count");
                    if (tempcount != null) {
                        count = Integer.parseInt(tempcount);
                    }

                    String keysValue[] = new String[3];
                    String keysIndex[] = new String[3];

                    maintainableMgr = MaintainableMgr.getInstance();
                    //categoryTemp = maintainableMgr.getOnArbitraryDoubleKey("1","key3","0","key5");
                    Vector EquipByDep = new Vector();
                    userObj = (WebBusinessObject) session.getAttribute("loggedUser");
                    projectId = userObj.getAttribute("projectID").toString();
                    try {

//                        EquipByDep = maintainableMgr.getOnArbitraryDoubleKey(departmentId, "key6",projectId,"key11");

                        keysValue[0] = "1";
                        keysValue[1] = "0";
                        keysValue[2] = departmentId;
                        keysIndex[0] = "key3";
                        keysIndex[1] = "key5";
                        keysIndex[2] = "key6";

                        EquipByDep = maintainableMgr.getOnArbitraryNumberKey(3, keysValue, keysIndex);

                    } catch (SQLException ex) {
                        logger.error(ex.getMessage());
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }
                    category = new Vector();
//                    for (int i = 0; i < EquipByDep.size(); i++) {
//                        wbo = (WebBusinessObject) EquipByDep.get(i);
//                        category.add(wbo);
//                    }

                    count = 0;
                    tempcount = (String) request.getParameter("count");
                    if (tempcount != null) {
                        count = Integer.parseInt(tempcount);
                    }
//                    index=(count+1)*10;
                    index = (count + 1) * EquipByDep.size();
                    checkattched = new Vector();
                    supplementMgr = SupplementMgr.getInstance();
                    id = "";
                    String parentId = "";
                    if (EquipByDep.size() < index) {
                        index = EquipByDep.size();
                    }
                    for (int i = count * 10; i < index; i++) {
                        wbo = (WebBusinessObject) EquipByDep.get(i);
                        id = (String) wbo.getAttribute("id");
                        parentId = (String) wbo.getAttribute("parentId");
                        if (!parentId.equals("0")) {
                            checkattched = supplementMgr.search(id);

                            if (checkattched.size() > 0) {
                                wbo.setAttribute("nowStatus", "attached");
                            } else {
                                checkattched = supplementMgr.searchAllowedEqps(id);
                                if (checkattched.size() > 0) {
                                    wbo.setAttribute("nowStatus", "attached");
                                } else {
                                    wbo.setAttribute("nowStatus", "notattached");
                                }
                            }
                            category.add(wbo);
                        } else {
                            EquipByDep.removeElementAt(i);
                            if (EquipByDep.size() < index) {
                                index = EquipByDep.size();
                            }
                            i--;
                        }
                    }

                    noOfLinks = EquipByDep.size() / 10f;
                    temp = "" + noOfLinks;
                    intNo = Integer.parseInt(temp.substring(temp.indexOf(".") + 1, temp.length()));
                    links = (int) noOfLinks;
                    if (intNo > 0) {
                        links++;
                    }
                    if (links == 1) {
                        links = 0;
                    }

                    lastFilter = url;
                    session.setAttribute("lastFilter", lastFilter);

                    topMenu = new Hashtable();
                    tempVec = new Vector();
                    topMenu = (Hashtable) request.getSession().getAttribute("topMenu");
                    if (topMenu != null && topMenu.size() > 0) {
                        tempVec = new Vector();
                        tempVec.add("lastFilter");
                        tempVec.add(lastFilter);
                        topMenu.put("lastFilter", tempVec);
                    } else {
                        topMenu = new Hashtable();
                        topMenu.put("jobOrder", new Vector());
                        topMenu.put("maintItem", new Vector());
                        topMenu.put("schedule", new Vector());
                        topMenu.put("equipment", new Vector());
                        tempVec = new Vector();
                        tempVec.add("lastFilter");
                        tempVec.add(lastFilter);
                        topMenu.put("lastFilter", tempVec);

                    }

                    request.getSession().setAttribute("topMenu", topMenu);

                    session.removeAttribute("CategoryID");
                    servedPage = "/docs/newEquipment/equipment_list.jsp";
                    request.setAttribute("department", "" + departmentId);
                    request.setAttribute("count", "" + count);
                    request.setAttribute("noOfLinks", "" + links);
                    request.setAttribute("fullUrl", url);
                    request.setAttribute("url", url);
                    request.setAttribute("data", category);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 38:
                    EquipmentSuppliersMgr equipmentSuppliersMgr = EquipmentSuppliersMgr.getInstance();

                    Vector vecSuppliers = equipmentSuppliersMgr.getSuppliersByEquipment(request);
                    servedPage = "/docs/newEquipment/new_equipment_supplier.jsp";
                    request.setAttribute("vecSuppliers", vecSuppliers);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 39:

                    equipmentSuppliersMgr = EquipmentSuppliersMgr.getInstance();
                    if (equipmentSuppliersMgr.saveObject(request)) {
                        request.setAttribute("Status", "Ok");
                    } else {
                        request.setAttribute("Status", "No");
                    }
                    vecSuppliers = equipmentSuppliersMgr.getSuppliersByEquipment(request);
                    servedPage = "/docs/newEquipment/new_equipment_supplier.jsp";
                    request.setAttribute("vecSuppliers", vecSuppliers);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 40:
                    SupplierMgr supplierMgr = SupplierMgr.getInstance();
                    vecSuppliers = supplierMgr.getAllSuppliersByEquipment(request);
                    servedPage = "/docs/newEquipment/supplier_list.jsp";
                    request.setAttribute("data", vecSuppliers);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 41:
                    equipmentSuppliersMgr = EquipmentSuppliersMgr.getInstance();
                    equipmentSuppliersMgr.deleteObject(request);
                    supplierMgr = SupplierMgr.getInstance();
                    vecSuppliers = supplierMgr.getAllSuppliersByEquipment(request);
                    servedPage = "/docs/newEquipment/supplier_list.jsp";
                    request.setAttribute("data", vecSuppliers);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 42:
                    servedPage = "/docs/newEquipment/search_equipment_By_productioLine.jsp";
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 43:
                    String productLineId = request.getParameter("producteLine");
                    url = "EquipmentServlet?op=ResultSearchEquipByPro&producteLine=" + productLineId;
                    maintainableMgr = MaintainableMgr.getInstance();

                    keysValue = new String[3];
                    keysIndex = new String[3];

                    Vector EquipByProLine = new Vector();
                    userObj = (WebBusinessObject) session.getAttribute("loggedUser");
                    try {
//                        EquipByProLine = maintainableMgr.getOnArbitraryDoubleKey(productLineId, "key7",userObj.getAttribute("projectID").toString(),"key11");
                        keysValue[0] = "1";
                        keysValue[1] = "0";
                        keysValue[2] = productLineId;
                        keysIndex[0] = "key3";
                        keysIndex[1] = "key5";
                        keysIndex[2] = "key7";
                        EquipByProLine = maintainableMgr.getOnArbitraryNumberKey(3, keysValue, keysIndex);

                    } catch (SQLException ex) {
                        logger.error(ex.getMessage());
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }
                    category = new Vector();
//                    for (int i = 0; i < EquipByProLine.size(); i++) {
//                        wbo = (WebBusinessObject) EquipByProLine.get(i);
//
//                        category.add(wbo);
//                        //                  }
//                    }

                    count = 0;
                    tempcount = (String) request.getParameter("count");
                    if (tempcount != null) {
                        count = Integer.parseInt(tempcount);
                    }
//                    index=(count+1)*10;
                    index = (count + 1) * EquipByProLine.size();
                    if (EquipByProLine.size() < index) {
                        index = EquipByProLine.size();
                    }

                    checkattched = new Vector();
                    supplementMgr = SupplementMgr.getInstance();
                    id = "";
                    if (EquipByProLine.size() < index) {
                        index = EquipByProLine.size();
                    }
                    for (int i = count * 10; i < index; i++) {
                        wbo = (WebBusinessObject) EquipByProLine.get(i);
                        id = (String) wbo.getAttribute("id");
                        checkattched = supplementMgr.search(id);
                        if (checkattched.size() > 0) {
                            wbo.setAttribute("nowStatus", "attached");
                        } else {
                            checkattched = supplementMgr.searchAllowedEqps(id);
                            if (checkattched.size() > 0) {
                                wbo.setAttribute("nowStatus", "attached");
                            } else {
                                wbo.setAttribute("nowStatus", "notattached");
                            }
                        }
                        category.add(wbo);
                    }

                    noOfLinks = EquipByProLine.size() / 10f;
                    temp = "" + noOfLinks;
                    intNo = Integer.parseInt(temp.substring(temp.indexOf(".") + 1, temp.length()));
                    links = (int) noOfLinks;
                    if (intNo > 0) {
                        links++;
                    }
                    if (links == 1) {
                        links = 0;
                    }

                    lastFilter = url;
                    session.setAttribute("lastFilter", lastFilter);

                    topMenu = new Hashtable();
                    tempVec = new Vector();
                    topMenu = (Hashtable) request.getSession().getAttribute("topMenu");
                    if (topMenu != null && topMenu.size() > 0) {
                        tempVec = new Vector();
                        tempVec.add("lastFilter");
                        tempVec.add(lastFilter);
                        topMenu.put("lastFilter", tempVec);
                    } else {
                        topMenu = new Hashtable();
                        topMenu.put("jobOrder", new Vector());
                        topMenu.put("maintItem", new Vector());
                        topMenu.put("schedule", new Vector());
                        topMenu.put("equipment", new Vector());
                        tempVec = new Vector();
                        tempVec.add("lastFilter");
                        tempVec.add(lastFilter);
                        topMenu.put("lastFilter", tempVec);

                    }

                    request.getSession().setAttribute("topMenu", topMenu);

                    session.removeAttribute("CategoryID");
                    servedPage = "/docs/newEquipment/equipment_list.jsp";
                    request.setAttribute("producteLine", "" + productLineId);
                    request.setAttribute("count", "" + count);
                    request.setAttribute("noOfLinks", "" + links);
                    request.setAttribute("fullUrl", url);
                    request.setAttribute("url", url);
                    request.setAttribute("data", category);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 44:
                    count = 0;
                    url = "EquipmentServlet?op=ListAttachedEquipment";
                    tempcount = (String) request.getParameter("count");
                    if (tempcount != null) {
                        count = Integer.parseInt(tempcount);
                    }

                    category = new Vector();
                    maintainableMgr = MaintainableMgr.getInstance();
                    WebBusinessObject userWbo = (WebBusinessObject) session.getAttribute("loggedUser");

//                    String parameters[]={"0","1","0",userWbo.getAttribute("projectID").toString()};
//                    String keys2[]={"key8","key3","key5","key11"};
//                    Vector vecAttachedEquipment =maintainableMgr.getOnArbitraryNumberKey(4,parameters,keys2);

                    String parameters[] = {"0", "1", "0"};
                    String keys2[] = {"key8", "key3", "key5"};
                    Vector vecAttachedEquipment = maintainableMgr.getOnArbitraryNumberKey(3, parameters, keys2);

//                    Vector vecAttachedEqps = maintainableMgr.getOnArbitraryDoubleKey("0", "key8", "1", "key3");

//                    Vector vecAttachedEquipment = new Vector();
//                    WebBusinessObject tempWbo=new WebBusinessObject();
//                    for(int i=0;i<vecAttachedEqps.size();i++) {
//                        tempWbo=new WebBusinessObject();
//                        tempWbo=(WebBusinessObject)vecAttachedEqps.get(i);
//                        if(tempWbo.getAttribute("isDeleted").toString().equalsIgnoreCase("0"))
//                            vecAttachedEquipment.add(tempWbo);
//
//                    }

                    session.removeAttribute("CategoryID");
                    servedPage = "/docs/newEquipment/equipment_list.jsp";

                    checkattched = new Vector();
                    id = "";
                    supplementMgr = SupplementMgr.getInstance();
//                    index=(count+1)*10;
                    index = (count + 1) * vecAttachedEquipment.size();
                    if (vecAttachedEquipment.size() < index) {
                        index = vecAttachedEquipment.size();
                    }
                    for (int i = count * 10; i < index; i++) {
                        wbo = (WebBusinessObject) vecAttachedEquipment.get(i);
                        id = (String) wbo.getAttribute("id");
                        checkattched = supplementMgr.search(id);
                        if (checkattched.size() > 0) {
                            wbo.setAttribute("nowStatus", "attached");
                        } else {
                            checkattched = supplementMgr.searchAllowedEqps(id);
                            if (checkattched.size() > 0) {
                                wbo.setAttribute("nowStatus", "attached");
                            } else {
                                wbo.setAttribute("nowStatus", "notattached");
                            }
                        }
                        category.add(wbo);
                    }

                    noOfLinks = vecAttachedEquipment.size() / 10f;
                    temp = "" + noOfLinks;
                    intNo = Integer.parseInt(temp.substring(temp.indexOf(".") + 1, temp.length()));
                    links = (int) noOfLinks;

                    if (intNo > 0) {
                        links++;
                    }
                    if (links == 1) {
                        links = 0;
                    }

                    lastFilter = "EquipmentServlet?op=ListAttachedEquipment";
                    session.setAttribute("lastFilter", lastFilter);

                    topMenu = new Hashtable();
                    tempVec = new Vector();
                    topMenu = (Hashtable) request.getSession().getAttribute("topMenu");
                    if (topMenu != null && topMenu.size() > 0) {
                        tempVec = new Vector();
                        tempVec.add("lastFilter");
                        tempVec.add(lastFilter);
                        topMenu.put("lastFilter", tempVec);
                    } else {
                        topMenu = new Hashtable();
                        topMenu.put("jobOrder", new Vector());
                        topMenu.put("maintItem", new Vector());
                        topMenu.put("schedule", new Vector());
                        topMenu.put("equipment", new Vector());
                        tempVec = new Vector();
                        tempVec.add("lastFilter");
                        tempVec.add(lastFilter);
                        topMenu.put("lastFilter", tempVec);

                    }

                    request.getSession().setAttribute("topMenu", topMenu);

                    request.setAttribute("count", "" + count);
                    request.setAttribute("noOfLinks", "" + links);
                    request.setAttribute("fullUrl", url);
                    request.setAttribute("url", url);
                    request.setAttribute("data", category);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 45:

                    DelayReasonsMgr delayMgr = DelayReasonsMgr.getInstance();
                    issueId = (String) request.getParameter("issueId");
                    servedPage = "/add_delay_reason.jsp";
                    String backTo = (String) request.getParameter("backTo");
                    if (backTo == null || backTo.equalsIgnoreCase("")) {
                        backTo = "tree";
                    }

                    Vector reasons = new Vector();
                    reasons = delayMgr.getOnArbitraryKey(issueId, "key1");

                    request.setAttribute("reasons", reasons);
                    request.setAttribute("backTo", backTo);
                    request.setAttribute("issueId", issueId);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 46:

                    delayMgr = DelayReasonsMgr.getInstance();
                    backTo = (String) request.getParameter("backTo");

                    String status = "no";
                    boolean result = false;
                    try {
                        result = delayMgr.saveObject(request, session);
                    } catch (Exception e) {
                    }
                    issueId = request.getParameter("issueId");
                    reasons = new Vector();
                    reasons = delayMgr.getOnArbitraryKey(issueId, "key1");

                    servedPage = "/add_delay_reason.jsp";
                    if (result) {
                        status = "ok";
                    }

                    request.setAttribute("issueId", request.getParameter("issueId"));
                    request.setAttribute("reasons", reasons);
                    request.setAttribute("backTo", backTo);
                    request.setAttribute("Status", status);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);

                    break;

                case 47:

                    delayMgr = DelayReasonsMgr.getInstance();
                    issueId = (String) request.getParameter("issueId");
                    Vector delayReasons = new Vector();
                    try {
                        delayReasons = delayMgr.getDelayReasons(issueId);
                    } catch (Exception e) {
                    }

                    servedPage = "/docs/issue/view_delay_reason.jsp";

                    request.setAttribute("issueId", issueId);
                    request.setAttribute("delayReasons", delayReasons);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);

                    break;
                case 48:
                    maintainableMgr = MaintainableMgr.getInstance();
                    equipmentID = request.getParameter("eID");
                    equipmentWBO = maintainableMgr.getOnSingleKey(equipmentID);

                    parentWBO = (WebBusinessObject) maintainableMgr.getOnSingleKey(equipmentWBO.getAttribute("parentId").toString());

                    tempList = maintainableMgr.getCashedTableAsBusObjects();
                    categoryList = new ArrayList();

                    if (parentWBO.getAttribute("isMaintainable").toString().equalsIgnoreCase("1")) {
                        for (int i = 0; i < tempList.size(); i++) {
                            wbo = (WebBusinessObject) tempList.get(i);
                            if (wbo.getAttribute("isMaintainable").toString().equalsIgnoreCase("1")) {
                                categoryList.add(wbo);
                            }
                        }
                    } else if (parentWBO.getAttribute("isMaintainable").toString().equalsIgnoreCase("0")) {
                        for (int i = 0; i < tempList.size(); i++) {
                            wbo = (WebBusinessObject) tempList.get(i);
                            if (wbo.getAttribute("isMaintainable").toString().equalsIgnoreCase("0")) {
                                categoryList.add(wbo);
                            }
                        }
                    }

                    servedPage = "/docs/newEquipment/update_equipment_manufacturing.jsp";
                    request.setAttribute("equipmentWBO", equipmentWBO);
                    request.setAttribute("categoryList", categoryList);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 49:
                    servedPage = "/docs/newEquipment/update_equipment_manufacturing.jsp";
                    eID = (String) request.getParameter("eID");
                    maintainableMgr = MaintainableMgr.getInstance();

                    equipmentWBO = maintainableMgr.getOnSingleKey(eID);

                    parentWbo = (WebBusinessObject) maintainableMgr.getOnSingleKey(equipmentWBO.getAttribute("parentId").toString());

                    wbo = null;
                    ht = new Hashtable();

                    //maintenable unit data
                    ht.put("id", request.getParameter("eID"));

                    if (request.getParameter("modelNo").toString().equalsIgnoreCase("") || request.getParameter("modelNo").toString() == null) {
                        ht.put("modelNo", "&#1575;&#1604;&#1605;&#1587;&#1578;&#1582;&#1583;&#1605; &#1604;&#1605; &#1610;&#1583;&#1582;&#1604; &#1576;&#1610;&#1575;&#1606;&#1575;&#1578;");
                    } else {
                        ht.put("modelNo", request.getParameter("modelNo"));
                    }

                    if (request.getParameter("serialNo").toString().equalsIgnoreCase("") || request.getParameter("serialNo").toString() == null) {
                        ht.put("serialNo", "&#1575;&#1604;&#1605;&#1587;&#1578;&#1582;&#1583;&#1605; &#1604;&#1605; &#1610;&#1583;&#1582;&#1604; &#1576;&#1610;&#1575;&#1606;&#1575;&#1578;");
                    } else {
                        ht.put("serialNo", request.getParameter("serialNo"));
                    }

                    if (request.getParameter("manufacturer").toString().equalsIgnoreCase("") || request.getParameter("manufacturer").toString() == null) {
                        ht.put("manufacturer", "&#1575;&#1604;&#1605;&#1587;&#1578;&#1582;&#1583;&#1605; &#1604;&#1605; &#1610;&#1583;&#1582;&#1604; &#1576;&#1610;&#1575;&#1606;&#1575;&#1578;");
                    } else {
                        ht.put("manufacturer", request.getParameter("manufacturer"));
                    }

                    try {
                        if (!maintainableMgr.getDoubleNameforUpdate(eID, request.getParameter("equipmentName"))) {
                            if (maintainableMgr.updateEqManuf(new WebBusinessObject(ht))) {
                                maintainableMgr.cashData();
                                request.setAttribute("Status", "Ok");
                            } else {
                                request.setAttribute("Status", "No");
                            }
                        } else {
                            request.setAttribute("Status", "No");
                            request.setAttribute("name", "Duplicate Name");
                        }
                    } catch (NoUserInSessionException ex) {
                        logger.error(ex.getMessage());
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }

                    maintainableMgr = MaintainableMgr.getInstance();
                    tempList = maintainableMgr.getCashedTableAsBusObjects();
                    categoryList = new ArrayList();

                    equipBase = request.getParameter("base");

                    if (parentWbo.getAttribute("isMaintainable").toString().equalsIgnoreCase("0")) {
                        for (int i = 0; i < tempList.size(); i++) {
                            wbo = (WebBusinessObject) tempList.get(i);
                            if (wbo.getAttribute("isMaintainable").toString().equalsIgnoreCase("0")) {
                                categoryList.add(wbo);
                            }
                        }
                    } else if (parentWbo.getAttribute("isMaintainable").toString().equalsIgnoreCase("1")) {
                        for (int i = 0; i < tempList.size(); i++) {
                            wbo = (WebBusinessObject) tempList.get(i);
                            if (wbo.getAttribute("isMaintainable").toString().equalsIgnoreCase("1")) {
                                categoryList.add(wbo);
                            }
                        }
                    }

                    equipmentWBO = maintainableMgr.getOnSingleKey(request.getParameter("eID"));

                    request.setAttribute("categoryList", categoryList);
                    request.setAttribute("equipmentWBO", equipmentWBO);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 50:
                    maintainableMgr = MaintainableMgr.getInstance();
                    equipmentID = request.getParameter("eID");
                    equipmentWBO = maintainableMgr.getOnSingleKey(equipmentID);

                    parentWBO = (WebBusinessObject) maintainableMgr.getOnSingleKey(equipmentWBO.getAttribute("parentId").toString());
                    tempList = maintainableMgr.getCashedTableAsBusObjects();
                    categoryList = new ArrayList();

                    if (parentWBO.getAttribute("isMaintainable").toString().equalsIgnoreCase("1")) {
                        for (int i = 0; i < tempList.size(); i++) {
                            wbo = (WebBusinessObject) tempList.get(i);
                            if (wbo.getAttribute("isMaintainable").toString().equalsIgnoreCase("1")) {
                                categoryList.add(wbo);
                            }
                        }
                    } else if (parentWBO.getAttribute("isMaintainable").toString().equalsIgnoreCase("0")) {
                        for (int i = 0; i < tempList.size(); i++) {
                            wbo = (WebBusinessObject) tempList.get(i);
                            if (wbo.getAttribute("isMaintainable").toString().equalsIgnoreCase("0")) {
                                categoryList.add(wbo);
                            }
                        }
                    }

                    servedPage = "/docs/newEquipment/update_equipment_operation.jsp";
                    request.setAttribute("equipmentWBO", equipmentWBO);
                    request.setAttribute("categoryList", categoryList);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 51:
                    servedPage = "/docs/newEquipment/update_equipment_operation.jsp";
                    eID = (String) request.getParameter("eID");
                    maintainableMgr = MaintainableMgr.getInstance();

                    equipmentWBO = maintainableMgr.getOnSingleKey(eID);
                    parentWbo = (WebBusinessObject) maintainableMgr.getOnSingleKey(equipmentWBO.getAttribute("parentId").toString());

                    wbo = null;
                    ht = new Hashtable();

                    //maintenable unit data
                    ht.put("id", request.getParameter("eID"));
                    ht.put("rateType", request.getParameter("eqptype"));
                    ht.put("oldrateType", request.getParameter("oldeqptype"));

                    if (request.getParameter("opration").toString().equalsIgnoreCase("Countinous")) {
                        ht.put("opType", "1");
                    } else {
                        ht.put("opType", "2");
                    }

                    ht.put("equipID", request.getParameter("eID"));

                    //Equipment Operation Data
                    ht.put("opeartionType", request.getParameter("opration"));
                    ht.put("average", new Integer(request.getParameter("average")));
                    if (!request.getParameter("eqptype").toString().equals(request.getParameter("oldeqptype").toString())) {
                        try {
                            averageUnitMgr.deleteOnArbitraryKey(request.getParameter("eID").toString(), "key1");
                            readingRateUnitMgr.deleteOnArbitraryKey(request.getParameter("eID").toString(), "key1");
                        } catch (SQLException ex) {
                            logger.error(ex.getMessage());
                        } catch (Exception ex) {
                            logger.error(ex.getMessage());
                        }
                    }

                    try {
                        if (!maintainableMgr.getDoubleNameforUpdate(eID, request.getParameter("equipmentName"))) {
                            if (maintainableMgr.updateEqOperation(new WebBusinessObject(ht))) {
                                maintainableMgr.cashData();
                                request.setAttribute("Status", "Ok");
                            } else {
                                request.setAttribute("Status", "No");
                            }
                        } else {
                            request.setAttribute("Status", "No");
                            request.setAttribute("name", "Duplicate Name");
                        }
                    } catch (NoUserInSessionException ex) {
                        logger.error(ex.getMessage());
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }

                    maintainableMgr = MaintainableMgr.getInstance();
                    tempList = maintainableMgr.getCashedTableAsBusObjects();
                    categoryList = new ArrayList();


                    equipBase = request.getParameter("base");

                    if (parentWbo.getAttribute("isMaintainable").toString().equalsIgnoreCase("0")) {
                        for (int i = 0; i < tempList.size(); i++) {
                            wbo = (WebBusinessObject) tempList.get(i);
                            if (wbo.getAttribute("isMaintainable").toString().equalsIgnoreCase("0")) {
                                categoryList.add(wbo);
                            }
                        }
                    } else if (parentWbo.getAttribute("isMaintainable").toString().equalsIgnoreCase("1")) {
                        for (int i = 0; i < tempList.size(); i++) {
                            wbo = (WebBusinessObject) tempList.get(i);
                            if (wbo.getAttribute("isMaintainable").toString().equalsIgnoreCase("1")) {
                                categoryList.add(wbo);
                            }
                        }
                    }

                    equipmentWBO = maintainableMgr.getOnSingleKey(request.getParameter("eID"));

                    request.setAttribute("categoryList", categoryList);
                    request.setAttribute("equipmentWBO", equipmentWBO);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;



                case 52:
                    maintainableMgr = MaintainableMgr.getInstance();
                    equipmentID = request.getParameter("eID");
                    equipmentWBO = maintainableMgr.getOnSingleKey(equipmentID);

                    parentWBO = (WebBusinessObject) maintainableMgr.getOnSingleKey(equipmentWBO.getAttribute("parentId").toString());
                    tempList = maintainableMgr.getCashedTableAsBusObjects();
                    categoryList = new ArrayList();

                    if (parentWBO.getAttribute("isMaintainable").toString().equalsIgnoreCase("1")) {
                        for (int i = 0; i < tempList.size(); i++) {
                            wbo = (WebBusinessObject) tempList.get(i);
                            if (wbo.getAttribute("isMaintainable").toString().equalsIgnoreCase("1")) {
                                categoryList.add(wbo);
                            }
                        }
                    } else if (parentWBO.getAttribute("isMaintainable").toString().equalsIgnoreCase("0")) {
                        for (int i = 0; i < tempList.size(); i++) {
                            wbo = (WebBusinessObject) tempList.get(i);
                            if (wbo.getAttribute("isMaintainable").toString().equalsIgnoreCase("0")) {
                                categoryList.add(wbo);
                            }
                        }
                    }

                    servedPage = "/docs/newEquipment/update_equipment_warranty.jsp";
                    request.setAttribute("equipmentWBO", equipmentWBO);
                    request.setAttribute("categoryList", categoryList);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 53:
                    servedPage = "/docs/newEquipment/update_equipment_warranty.jsp";
                    eID = (String) request.getParameter("eID");
                    maintainableMgr = MaintainableMgr.getInstance();

                    equipmentWBO = maintainableMgr.getOnSingleKey(eID);
                    parentWbo = (WebBusinessObject) maintainableMgr.getOnSingleKey(equipmentWBO.getAttribute("parentId").toString());

                    wbo = null;
                    ht = new Hashtable();

                    dropdownDate = new DropdownDate();
                    c = Calendar.getInstance();
                    /// Compare date and Time///
//                    acquiringDate = dropdownDate.getDate(request.getParameter("acquiringDate")).toString();
//                    warrantyDate = dropdownDate.getDate(request.getParameter("warrantyDate")).toString();
//
//                    dateformat = new SimpleDateFormat("yyyy-MM-dd");
//                    try {
//                        Date acqdate = dateformat.parse(acquiringDate);
//                        Date warrdate = dateformat.parse(warrantyDate);
//                        id1 = acqdate.getTime();
//                        id2 = warrdate.getTime();
//                    } catch (Exception ex) {
//                        logger.error(ex.getMessage());
//                    }

//                    supplier equipment data
//                    ht.put("supplierID", request.getParameter("supplier"));
//                    ht.put("purchaseDate", new java.sql.Date(dropdownDate.getDate(request.getParameter("acquiringDate")).getTime()));
//                    ht.put("purchasePrice", new Float(request.getParameter("price")));
//                    ht.put("currentValue", new Float(request.getParameter("currentValue")));
//                    ht.put("displosedDate",  new java.sql.Date(dropdownDate.getDate(request.getParameter("disposedDate")).getTime()));
//                    ht.put("contractorEmp", request.getParameter("contractor"));
//                    ht.put("warranty", request.getParameter("contract"));
//                    ht.put("warrantyDate", new java.sql.Date(dropdownDate.getDate(request.getParameter("warrantyDate")).getTime()));
//                    ht.put("notes", request.getParameter("eqDescription"));
                    ht.put("equipID", request.getParameter("eID"));

                    try {
                        if (!maintainableMgr.getDoubleNameforUpdate(eID, request.getParameter("equipmentName"))) {
//                            if (maintainableMgr.updateEqWarranty(new WebBusinessObject(ht))) {
//                                maintainableMgr.cashData();
//                                request.setAttribute("Status", "Ok");
//                            } else {
//                                request.setAttribute("Status", "No");
//                            }
                        } else {
                            request.setAttribute("Status", "No");
                            request.setAttribute("name", "Duplicate Name");
                        }

                    } catch (NoUserInSessionException ex) {
                        logger.error(ex.getMessage());
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }

                    maintainableMgr = MaintainableMgr.getInstance();
                    tempList = maintainableMgr.getCashedTableAsBusObjects();
                    categoryList = new ArrayList();


                    equipBase = request.getParameter("base");

                    if (parentWbo.getAttribute("isMaintainable").toString().equalsIgnoreCase("0")) {
                        for (int i = 0; i < tempList.size(); i++) {
                            wbo = (WebBusinessObject) tempList.get(i);
                            if (wbo.getAttribute("isMaintainable").toString().equalsIgnoreCase("0")) {
                                categoryList.add(wbo);
                            }
                        }
                    } else if (parentWbo.getAttribute("isMaintainable").toString().equalsIgnoreCase("1")) {
                        for (int i = 0; i < tempList.size(); i++) {
                            wbo = (WebBusinessObject) tempList.get(i);
                            if (wbo.getAttribute("isMaintainable").toString().equalsIgnoreCase("1")) {
                                categoryList.add(wbo);
                            }
                        }
                    }

                    equipmentWBO = maintainableMgr.getOnSingleKey(request.getParameter("eID"));

                    request.setAttribute("categoryList", categoryList);
                    request.setAttribute("equipmentWBO", equipmentWBO);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;


                case 54:
                    maintainableMgr = MaintainableMgr.getInstance();
                    equipmentID = request.getParameter("equipmentID");
                    equipmentWBO = maintainableMgr.getOnSingleKey(equipmentID);

                    parentWBO = (WebBusinessObject) maintainableMgr.getOnSingleKey(equipmentWBO.getAttribute("parentId").toString());

                    tempList = maintainableMgr.getCashedTableAsBusObjects();
                    categoryList = new ArrayList();

                    if (parentWBO.getAttribute("isMaintainable").toString().equalsIgnoreCase("1")) {
                        for (int i = 0; i < tempList.size(); i++) {
                            wbo = (WebBusinessObject) tempList.get(i);
                            if (wbo.getAttribute("isMaintainable").toString().equalsIgnoreCase("1")) {
                                categoryList.add(wbo);
                            }
                        }
                    } else if (parentWBO.getAttribute("isMaintainable").toString().equalsIgnoreCase("0")) {
                        for (int i = 0; i < tempList.size(); i++) {
                            wbo = (WebBusinessObject) tempList.get(i);
                            if (wbo.getAttribute("isMaintainable").toString().equalsIgnoreCase("0")) {
                                categoryList.add(wbo);
                            }
                        }
                    }

                    servedPage = "/docs/newEquipment/update_equipment.jsp";

                    request.setAttribute("equipmentWBO", equipmentWBO);
                    request.setAttribute("categoryList", categoryList);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 55:

                    //servedPage = "/docs/newEquipment/update_equipment.jsp";
                    servedPage = "EquipmentServlet?op=showTree&ID=" + request.getParameter("mainCategoryType");
                    eID = (String) request.getParameter("eID");
                    mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();
                    maintainableMgr = MaintainableMgr.getInstance();
                    loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                    String userId = loggedUser.getAttribute("userId").toString();

                    dropdownDate = new DropdownDate();
                    c = Calendar.getInstance();

                    parentWbo = (WebBusinessObject) maintainableMgr.getOnSingleKey(request.getParameter("parentCategory"));

                    wbo = null;
                    ht = new Hashtable();

                    //maintenable unit data
                    ht.put("id", request.getParameter("eID"));
                    ht.put("parentId", request.getParameter("parentCategory"));
                    ht.put("unitLevel", parentWbo.getAttribute("unitLevel").toString());
                    ht.put("unitNo", request.getParameter("equipmentNo"));

                    if (request.getParameter("engineNo").toString().equalsIgnoreCase("") || request.getParameter("engineNo").toString() == null) {
                        ht.put("engineNo", "&#1575;&#1604;&#1605;&#1587;&#1578;&#1582;&#1583;&#1605; &#1604;&#1605; &#1610;&#1583;&#1582;&#1604; &#1576;&#1610;&#1575;&#1606;&#1575;&#1578;");
                    } else {
                        ht.put("engineNo", request.getParameter("engineNo"));
                    }

//                    ht.put("engineNo", request.getParameter("engineNo"));
//                    ht.put("modelNo", request.getParameter("modelNo"));
//                    ht.put("serialNo", request.getParameter("serialNo"));
                    ht.put("unitName", request.getParameter("equipmentName"));
//                    ht.put("manufacturer", request.getParameter("manufacturer"));
                    ht.put("location", request.getParameter("locations"));
                    ht.put("dept", request.getParameter("depts"));
                    ht.put("status", request.getParameter("status"));
                    ht.put("desc", request.getParameter("equipmentDescription"));
                    ht.put("productionLine", request.getParameter("proLine"));
                    ht.put("user", userId);



                    String servDate = request.getParameter("serviceEntryDate").toString();
//                    if(servDate.contains("-")) {
//                        servDate=servDate.replaceAll("-","/");
//                        String []serviceDate = servDate.split("/");
//                        eYear=Integer.parseInt(serviceDate[0]);
//                        eMonth=Integer.parseInt(serviceDate[1]);
//                        eDay=Integer.parseInt(serviceDate[2]);
//                    }else{
//                        servDate=servDate.replaceAll("-","/");
//                        String []serviceDate = servDate.split("/");
//                        eYear=Integer.parseInt(serviceDate[2]);
//                        eMonth=Integer.parseInt(serviceDate[0]);
//                        eDay=Integer.parseInt(serviceDate[1]);
//                    }
//                    serviceEntryDate=new java.sql.Date(eYear-1900,eMonth-1,eDay);
                    dateParser = new DateParser();
                    servDate = servDate.replaceAll("-", "/");
                    java.sql.Date serviceEntryDate = dateParser.formatSqlDate(servDate);

                    ht.put("serviceEntryDate", serviceEntryDate);

                    if (request.getParameter("checkIsStandalone") == null) {
                        ht.put("isStandalone", "0");
                    } else {
                        if (request.getParameter("checkIsStandalone").toString().equals("0")) {
                            ht.put("isStandalone", "0");
                        } else {
                            ht.put("isStandalone", "1");
                        }
                    }

                    maintainablerecord = maintainableMgr.getOnSingleKey((String) request.getParameter("parentCategory"));
                    ht.put("mainCat", request.getParameter("mainCategoryType"));

                    try {
                        // if (!maintainableMgr.getDoubleNameforUpdate(eID, request.getParameter("equipmentName"))) {
                        if (maintainableMgr.updateEqBasicData(new WebBusinessObject(ht))) {
                            maintainableMgr.cashData();
                            request.setAttribute("Status", "Ok");
                        } else {
                            request.setAttribute("Status", "No");
                        }
                        //} else {
                        //   request.setAttribute("Status", "No");
                        //    request.setAttribute("name", "Duplicate Name");
                        // }

                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }


                    maintainableMgr = MaintainableMgr.getInstance();
                    tempList = maintainableMgr.getCashedTableAsBusObjects();
                    categoryList = new ArrayList();
                    equipBase = request.getParameter("base");
                    mainCategoryLists = mainCategoryTypeMgr.getAllAsArrayList();
                    if (parentWbo.getAttribute("isMaintainable").toString().equalsIgnoreCase("0")) {
                        for (int i = 0; i < tempList.size(); i++) {
                            wbo = (WebBusinessObject) tempList.get(i);
                            if (wbo.getAttribute("isMaintainable").toString().equalsIgnoreCase("0")) {
                                categoryList.add(wbo);
                            }
                        }
                    } else if (parentWbo.getAttribute("isMaintainable").toString().equalsIgnoreCase("1")) {
                        for (int i = 0; i < tempList.size(); i++) {
                            wbo = (WebBusinessObject) tempList.get(i);
                            if (wbo.getAttribute("isMaintainable").toString().equalsIgnoreCase("1")) {
                                categoryList.add(wbo);
                            }
                        }
                    }

                    equipmentWBO = maintainableMgr.getOnSingleKey(request.getParameter("eID"));
                    empBasicMgr = EmpBasicMgr.getInstance();
                    request.setAttribute("listWorkers", empBasicMgr.getCashedTableAsBusObjects());

                    request.setAttribute("mainCategory", mainCategoryLists);
                    request.setAttribute("categoryList", categoryList);
                    request.setAttribute("equipmentWBO", equipmentWBO);

                    //request.setAttribute("page", servedPage);
                    //this.forwardToServedPage(request, response);
                    this.forward(servedPage, request, response);
                    break;


                case 56:
                    loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                    supplementMgr = SupplementMgr.getInstance();
                    Vector getattachedEqps = supplementMgr.search(request.getParameter("equipmentID"));
                    Row row = null;
                    row = (Row) getattachedEqps.get(0);
                    String attachedEqID = row.getString(3);

                    unitDocMgr = unitDocMgr.getInstance();
                    imageList = unitDocMgr.getImagesList(attachedEqID);
                    imagesPath = new Vector();
                    servedPage = "/docs/unit_doc_handling/viewAttachedEqp.jsp";
                    request.setAttribute("page", servedPage);
                    for (int i = 0; i < imageList.size(); i++) {
                        randome = UniqueIDGen.getNextID();
                        len = randome.length();
                        String docID = ((WebBusinessObject) imageList.get(i)).getAttribute("docID").toString();
                        randFileName = new String("ran" + randome.substring(5, len) + ".jpeg");
                        imageDirPath = getServletContext().getRealPath("/images");
                        userHome = (String) loggedUser.getAttribute("userHome");
                        userImageDir = imageDirPath + "/" + userHome;
                        userBackendHome = web_inf_path + "/usr/" + userHome + "/";

                        RIPath = userImageDir + "/" + randFileName;


                        absPath = "images/" + userHome + "/" + randFileName;

                        docImage = new File(RIPath);

                        gifData = new BufferedInputStream(unitDocMgr.getImage(docID));
                        myImage = ImageIO.read(gifData);
                        ImageIO.write(myImage, "jpeg", docImage);
                        imagesPath.add(absPath);
                    }
                    request.setAttribute("equipID", attachedEqID);
                    request.setAttribute("imagePath", imagesPath);
                    forward("/docs/unit_doc_handling/viewAttachedEqp.jsp", request, response);

                    break;

                case 57:

                    String eqID = (String) request.getParameter("equipmentID");
                    maintainableMgr = MaintainableMgr.getInstance();
                    WebBusinessObject eqWbo = maintainableMgr.getOnSingleKey(eqID);

                    mode = (String) request.getParameter("currentMode");
                    servedPage = "/docs/newEquipment/add_warranty_data.jsp";
                    request.setAttribute("equipmentID", eqID);
                    request.setAttribute("currentMode", mode);
                    request.setAttribute("equipmentName", (String) eqWbo.getAttribute("unitName"));
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 58:

                    eqID = (String) request.getParameter("equipmentID");
                    mode = (String) request.getParameter("currentMode");
                    servedPage = "/docs/newEquipment/add_warranty_data.jsp";
                    maintainableMgr = MaintainableMgr.getInstance();
                    if (maintainableMgr.saveWarrantyData(request, eqID)) {
                        status = "ok";
                    } else {
                        status = "false";
                    }

                    request.setAttribute("status", status);
                    request.setAttribute("equipmentID", eqID);
                    request.setAttribute("currentMode", mode);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 59:

                    eqID = (String) request.getParameter("equipmentID");
                    mode = (String) request.getParameter("currentMode");
                    servedPage = "/docs/newEquipment/view_warranty_data.jsp";

                    SupplierEquipmentMgr equipSupMgr = SupplierEquipmentMgr.getInstance();
                    Vector warrantyData = equipSupMgr.getOnArbitraryKey(eqID, "key");

                    request.setAttribute("equipmentID", eqID);
                    request.setAttribute("warrantyData", warrantyData);
                    request.setAttribute("currentMode", mode);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 60:
                    mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();
                    categoryTemp = mainCategoryTypeMgr.getAllBasicTypeBySortingByID();
                    servedPage = "/docs/newEquipment/new_main_category.jsp";

                    request.setAttribute("data", categoryTemp);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 61:
                    mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();
                    maintainableMgr = MaintainableMgr.getInstance();
                    String notes = (String) request.getParameter("notes");
                    String typeName = (String) request.getParameter("typeName");
                    String apprivation = (String) request.getParameter("apprivation");
                    String basicCounter = (String) request.getParameter("basicCounter");
                    String standAlone = (String) request.getParameter("standAlone");
                    String departType = "NON";
                    try{
                        departType = (String) request.getParameter("departType");
                        if(departType == null || departType.equalsIgnoreCase("")){
                            departType = "NON";
                        }
                    }catch(Exception ex){
                        departType = "NON";
                    }
                    String isAgroupEq = "";
                    if (request.getParameter("isAgroupEq") == null) {
                        isAgroupEq = "0";
                    } else {
                        isAgroupEq = "1";
                    }

                    if (!mainCategoryTypeMgr.getDoubleName(typeName)) {
                        if (mainCategoryTypeMgr.saveObject(typeName, notes, apprivation, isAgroupEq, standAlone, departType, basicCounter, session)) {
                            request.setAttribute("status", "ok");
                        } else {
                            request.setAttribute("status", "fail");
                        }
                    } else {
                        request.setAttribute("name", "double");
                    }

                    categoryTemp = mainCategoryTypeMgr.getAllBasicTypeBySortingByID();

                    servedPage = "/docs/newEquipment/new_main_category.jsp";

                    request.setAttribute("data", categoryTemp);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 62:
                    mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();
                    ArrayList mainCategories = new ArrayList();
                    mainCategoryTypeMgr.cashData();
                    mainCategories = mainCategoryTypeMgr.getCashedTableAsBusObjects();
                    category = new Vector();
                    for (int i = 0; i < mainCategories.size(); i++) {
                        category.add(mainCategories.get(i));
                    }
                    servedPage = "/docs/newEquipment/main_category_list.jsp";

                    request.setAttribute("data", category);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 63:
                    servedPage = "/docs/newEquipment/view_main_category.jsp";
                    categoryID = request.getParameter("categoryID");
                    mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();
                    categoryWBO = new WebBusinessObject();
                    categoryWBO = mainCategoryTypeMgr.getOnSingleKey(categoryID);

                    request.setAttribute("categoryWBO", categoryWBO);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;
                case 64:
                    maintainableMgr = MaintainableMgr.getInstance();
                    categoryID = request.getParameter("categoryID");
                    mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();
                    categoryWBO = new WebBusinessObject();
                    categoryWBO = mainCategoryTypeMgr.getOnSingleKey(categoryID);

                    servedPage = "/docs/newEquipment/update_main_category.jsp";
                    request.setAttribute("categoryWBO", categoryWBO);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 65:
                    categoryID = request.getParameter("categoryID");
                    mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();
                    notes = (String) request.getParameter("notes");
                    typeName = (String) request.getParameter("typeName");
                    apprivation = (String) request.getParameter("apprivation");
                    standAlone = (String) request.getParameter("standAlone");
                    basicCounter = (String) request.getParameter("basicCounter");

                    isAgroupEq = "";
                    if (request.getParameter("isAgroupEq") == null) {
                        isAgroupEq = "0";
                    } else {
                        isAgroupEq = "1";
                    }
//                    if (!mainCategoryTypeMgr.getDoubleName(typeName)) {
                    if (mainCategoryTypeMgr.updateObject(typeName, notes, apprivation, isAgroupEq, categoryID, standAlone, basicCounter, session)) {
                        request.setAttribute("status", "ok");
                    } else {
                        request.setAttribute("status", "fail");
                    }
//                    }else
//                        request.setAttribute("name","double");

                    servedPage = "/docs/newEquipment/update_main_category.jsp";
                    categoryWBO = new WebBusinessObject();
                    categoryWBO = mainCategoryTypeMgr.getOnSingleKey(categoryID);
                    request.setAttribute("categoryWBO", categoryWBO);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 66:
                    mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();
                    categoryID = request.getParameter("categoryID");
                    if (mainCategoryTypeMgr.deleteOnSingleKey(categoryID)) {
                        request.setAttribute("deleteStatus", "");
                    }
                    mainCategories = new ArrayList();
                    mainCategoryTypeMgr.cashData();
                    mainCategories = mainCategoryTypeMgr.getCashedTableAsBusObjects();
                    category = new Vector();
                    for (int i = 0; i < mainCategories.size(); i++) {
                        category.add(mainCategories.get(i));
                    }
                    servedPage = "/docs/newEquipment/main_category_list.jsp";

                    request.setAttribute("data", category);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 67:
                    ArrayList allEquipments = new ArrayList();
                    Vector eqps = new Vector();
                    eqps = maintainableMgr.getOnArbitraryDoubleKey("0", "key3", "0", "key5");
                    wbo = new WebBusinessObject();

                    for (int i = 0; i < eqps.size(); i++) {
                        wbo = (WebBusinessObject) eqps.get(i);
                        //if(!wbo.getAttribute("parentId").toString().equalsIgnoreCase("0"))
                        allEquipments.add(wbo);
                    }

                    servedPage = "/docs/newEquipment/select_eq_report.jsp";
                    request.setAttribute("currentMode", "Ar");
                    request.setAttribute("data", allEquipments);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 68:
                    maintainableMgr = MaintainableMgr.getInstance();
                    Vector equipmetWboVec = null;

                    eqID = (String) request.getParameter("equipmentId");

                    String options[] = null;
                    options = (String[]) request.getParameterValues("equipmentData");

                    if (eqID.equalsIgnoreCase("all")) {
                        String query = "select ";
                        if (options == null || options.length <= 0) {
                            query += "UNIT_NAME, PARENT_ID, MAIN_TYPE_ID  ";
                        } else {
                            query += "UNIT_NAME , PARENT_ID, MAIN_TYPE_ID, ";
                            for (int i = 0; i < options.length; i++) {
                                query += options[i] + ",";
                            }
                            query = query.trim().substring(0, query.length() - 1);
                        }


                        query += " FROM maintainable_unit WHERE IS_DELETED = '0' and PARENT_ID != '0' order by PARENT_ID";

                        equipmetWboVec = maintainableMgr.getEquipmentRecordAll(query);
                        servedPage = "/docs/newEquipment/equipment_Report_All.jsp";
                    } else {
                        WebBusinessObject equipWbo = (WebBusinessObject) maintainableMgr.getOnSingleKey(eqID);

                        String query = "select ";
                        if (options == null || options.length <= 0) {
                            query += "UNIT_NAME, MAIN_TYPE_ID";
                        } else {
                            query += "UNIT_NAME , MAIN_TYPE_ID,";
                            for (int i = 0; i < options.length; i++) {
                                query += options[i] + ",";
                            }
                            query = query.trim().substring(0, query.length() - 1);
                        }


                        query += " FROM maintainable_unit WHERE PARENT_ID = ? and IS_DELETED = '0' order by UNIT_NAME ";

                        equipmetWboVec = maintainableMgr.getEquipmentRecord(query, eqID);

                        servedPage = "/docs/newEquipment/equipment_Report.jsp";
                        request.setAttribute("equipCatWbo", equipWbo);
                    }

                    mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();
                    Vector allMainCats = mainCategoryTypeMgr.getOnArbitraryKey("1", "key2");
                    Vector finalEqpsVec = checkIsAgroupEq(equipmetWboVec, allMainCats);
                    request.setAttribute("items", options);
                    request.setAttribute("data", finalEqpsVec);
                    this.forward(servedPage, request, response);

                    break;

                case 69:

                    mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();
                    ArrayList categories = new ArrayList();
                    categories = mainCategoryTypeMgr.getCashedTableAsBusObjects();
                    servedPage = "/docs/newEquipment/select_eq_report_mainType.jsp";
                    request.setAttribute("currentMode", "Ar");
                    request.setAttribute("data", categories);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 70:
                    maintainableMgr = MaintainableMgr.getInstance();
                    Vector parents = new Vector();
                    categoryId = (String) request.getParameter("categoryId");
                    mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();
                    WebBusinessObject catWbo = (WebBusinessObject) mainCategoryTypeMgr.getOnSingleKey(categoryId);
                    request.setAttribute("catName", catWbo.getAttribute("typeName").toString());
                    options = null;
                    options = (String[]) request.getParameterValues("equipmentData");

                    String query = "select ";
                    String query2 = "select ";
                    if (options == null || options.length <= 0) {
                        query += "UNIT_NAME ,ID";
                        query2 += "UNIT_NAME ,ID";
                    } else {
                        query += "UNIT_NAME ,ID ,";
                        query2 += "UNIT_NAME ,ID ,";
                        for (int i = 0; i < options.length; i++) {
                            query += options[i] + ",";
                            query2 += options[i] + ",";
                        }
                    }

                    query = query.trim().substring(0, query.length() - 1);
                    query2 = query2.trim().substring(0, query2.length() - 1);
                    String queryAllEqUnderMainId = query + " FROM maintainable_unit WHERE MAIN_TYPE_ID = ? and IS_DELETED = '0' and PARENT_ID != '0' order by UNIT_NAME ";
                    query += " FROM maintainable_unit WHERE MAIN_TYPE_ID = ? and IS_DELETED = '0' and PARENT_ID = '0' order by UNIT_NAME ";
                    query2 += " FROM maintainable_unit WHERE PARENT_ID = ? and IS_DELETED = '0' order by UNIT_NAME ";

                    Vector equipmetWboVecTest = maintainableMgr.getEquipmentRecord(queryAllEqUnderMainId, categoryId);

                    request.setAttribute("testData", equipmetWboVecTest);
                    parents = maintainableMgr.getEquipmentRecord(query, categoryId);
                    parentWbo = new WebBusinessObject();
                    parentId = "";
                    Hashtable parents_eqps = new Hashtable();
                    for (int i = 0; i < parents.size(); i++) {
                        parentWbo = new WebBusinessObject();
                        equipmetWboVec = new Vector();
                        parentWbo = (WebBusinessObject) parents.get(i);
                        parentId = parentWbo.getAttribute("id").toString();
                        equipmetWboVec = maintainableMgr.getEquipmentRecord(query2, parentId);
                        parents_eqps.put(parentId, equipmetWboVec);
                    }


                    servedPage = "/docs/newEquipment/equipment_Report_MainType.jsp";
                    request.setAttribute("catWbo", catWbo);
                    request.setAttribute("items", options);
                    request.setAttribute("parents", parents);
                    request.setAttribute("parents_eqps", parents_eqps);
                    this.forward(servedPage, request, response);

                    break;

                case 71:

                    mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();
                    categories = new ArrayList();
                    categories = mainCategoryTypeMgr.getCashedTableAsBusObjects();
                    servedPage = "/docs/reports/mainType_Report.jsp";
                    request.setAttribute("data", categories);
                    this.forward(servedPage, request, response);

                    break;

                case 72:
                    maintainableMgr = MaintainableMgr.getInstance();
                    allEquipments = new ArrayList();
                    eqps = new Vector();
                    eqps = maintainableMgr.getOnArbitraryDoubleKey("1", "key3", "0", "key5");
                    wbo = new WebBusinessObject();

                    for (int i = 0; i < eqps.size(); i++) {
                        wbo = (WebBusinessObject) eqps.get(i);
                        if (!wbo.getAttribute("parentId").toString().equalsIgnoreCase("0")) {
                            allEquipments.add(wbo);
                        }
                    }

                    servedPage = "/docs/reports/select_eqStatus_report.jsp";
                    request.setAttribute("currentMode", "Ar");
                    request.setAttribute("data", allEquipments);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 73:
                    maintainableMgr = MaintainableMgr.getInstance();
                    WebBusinessObject tempWboForId = new WebBusinessObject();
                    equipmetWboVec = null;
                    Vector eqReading = new Vector();
                    Vector getEqId = new Vector();
                    averageUnitMgr = AverageUnitMgr.getInstance();
                    WebBusinessObject readingWbo = new WebBusinessObject();
                    issueMgr = IssueMgr.getInstance();
                    Vector equips = new Vector();
                    issueTasksMgr = IssueTasksMgr.getInstance();
                    TaskMgr taskMgr = TaskMgr.getInstance();
                    Vector taskDetails = new Vector();
                    Vector issueTasksDetails = new Vector();
                    WebBusinessObject taskWbo = new WebBusinessObject();
                    Hashtable tasksHashTable = new Hashtable();
                    String taskId = null;
                    issueId = null;
                    WebBusinessObject unitWbo = new WebBusinessObject();
                    WebBusinessObject issueTaskWbo = new WebBusinessObject();
                    Vector issueTasks = new Vector();
                    QuantifiedMntenceMgr quantifiedMntenceMgr = QuantifiedMntenceMgr.getInstance();
                    MaintenanceItemMgr maintenanceItemMgr = MaintenanceItemMgr.getInstance();
                    LocalStoresItemsMgr localStoresItemsMgr = LocalStoresItemsMgr.getInstance();
                    Hashtable issueStoreParts = new Hashtable();
                    Vector quantifiedItems = new Vector();
                    Vector loaclitems = new Vector();
                    String unitScheduleId = null;
                    WebBusinessObject quanitifiedWbo = new WebBusinessObject();
                    WebBusinessObject item = new WebBusinessObject();


                    eqID = (String) request.getParameter("equipmentId");
                    getEqId = maintainableMgr.getOnArbitraryKey(eqID, "key4");
                    if (getEqId.size() > 0) {
                        tempWboForId = (WebBusinessObject) getEqId.get(0);
                        eqID = tempWboForId.getAttribute("id").toString();
                        eqReading = averageUnitMgr.getOnArbitraryKey(eqID, "key1");
                        equips = issueMgr.getOnArbitraryDoubleKey(eqID, "key6", "Finished", "key7");
                        wbo = new WebBusinessObject();



                        //loop to get maintainance items for each issue for eq
                        for (int i = 0; i < equips.size(); i++) {
                            issueTasksDetails = new Vector();
                            wbo = new WebBusinessObject();
                            issueId = "";
                            wbo = (WebBusinessObject) equips.get(i);
                            issueId = wbo.getAttribute("id").toString();
                            //get issue tasks
                            issueTasks = issueTasksMgr.getOnArbitraryKey(issueId, "key1");
                            for (int x = 0; x < issueTasks.size(); x++) {
                                taskId = "";
                                taskWbo = new WebBusinessObject();
                                issueTaskWbo = new WebBusinessObject();
                                issueTaskWbo = (WebBusinessObject) issueTasks.get(x);
                                taskId = issueTaskWbo.getAttribute("codeTask").toString();
                                //get task record
                                taskWbo = taskMgr.getOnSingleKey(taskId);
                                issueTasksDetails.add(taskWbo);
                            }
                            tasksHashTable.put(issueId, issueTasksDetails);
                        }

                        for (int i = 0; i < equips.size(); i++) {
                            wbo = new WebBusinessObject();
                            quantifiedItems = new Vector();
                            issueId = "";
                            unitScheduleId = "";
                            quantifiedItems = new Vector();
                            wbo = (WebBusinessObject) equips.get(i);
                            unitScheduleId = wbo.getAttribute("unitScheduleID").toString();
                            issueId = wbo.getAttribute("id").toString();
                            quantifiedItems = quantifiedMntenceMgr.getOnArbitraryKey(unitScheduleId, "key1");
                            for (int n = 0; n < quantifiedItems.size(); n++) {
                                quanitifiedWbo = new WebBusinessObject();
                                quanitifiedWbo = (WebBusinessObject) quantifiedItems.get(n);
                                String itemID = (String) quanitifiedWbo.getAttribute("itemId");
                                String is_Direct = (String) quanitifiedWbo.getAttribute("isDirectPrch");
                                if (is_Direct.equals("0")) {
                                    item = new WebBusinessObject();
                                    item = maintenanceItemMgr.getOnSingleKey(itemID);
                                    quanitifiedWbo.setAttribute("itemCode", item.getAttribute("itemCode"));
                                    quanitifiedWbo.setAttribute("itemDscrptn", item.getAttribute("itemDscrptn"));
                                } else {
                                    loaclitems = new Vector();
                                    loaclitems = localStoresItemsMgr.getOnArbitraryKey(itemID, "key1");
                                    for (int x = 0; x < loaclitems.size(); x++) {
                                        item = new WebBusinessObject();
                                        item = (WebBusinessObject) loaclitems.get(x);
                                        quanitifiedWbo.setAttribute("itemCode", item.getAttribute("itemCode"));
                                        quanitifiedWbo.setAttribute("itemDscrptn", item.getAttribute("itemName"));
                                    }
                                }
                            }
                            issueStoreParts.put(issueId, quantifiedItems);
                        }

                        maintainableMgr = MaintainableMgr.getInstance();
                        unitWbo = maintainableMgr.getOnSingleKey(eqID);
                        if (eqReading.size() > 0) {
                            readingWbo = (WebBusinessObject) eqReading.get(0);
                            unitWbo.setAttribute("lastReading", (String) readingWbo.getAttribute("acual_Reading"));
                            unitWbo.setAttribute("lastReadingDate", (String) readingWbo.getAttribute("entry_Time"));
                        }
                        request.setAttribute("equipIssues", equips);
                        request.setAttribute("issueTasks", tasksHashTable);
                        request.setAttribute("issueParts", issueStoreParts);
                        request.setAttribute("equipmentWbo", unitWbo);
                        servedPage = "/docs/reports/eqStatus_Report.jsp";
                        this.forward(servedPage, request, response);
                    } else {
                        maintainableMgr = MaintainableMgr.getInstance();
                        allEquipments = new ArrayList();
                        eqps = new Vector();
                        eqps = maintainableMgr.getOnArbitraryDoubleKey("1", "key3", "0", "key5");
                        wbo = new WebBusinessObject();

                        for (int i = 0; i < eqps.size(); i++) {
                            wbo = (WebBusinessObject) eqps.get(i);
                            if (!wbo.getAttribute("parentId").toString().equalsIgnoreCase("0")) {
                                allEquipments.add(wbo);
                            }
                        }
                        request.setAttribute("status", "fail");
                        servedPage = "/docs/reports/select_eqStatus_report.jsp";
                        request.setAttribute("currentMode", "Ar");
                        request.setAttribute("data", allEquipments);
                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);
                    }
                    break;

                case 74:
                    maintainableMgr = MaintainableMgr.getInstance();
                    allEquipments = new ArrayList();
                    eqps = new Vector();
                    eqps = maintainableMgr.getOnArbitraryDoubleKey("1", "key3", "0", "key5");
                    wbo = new WebBusinessObject();

                    for (int i = 0; i < eqps.size(); i++) {
                        wbo = (WebBusinessObject) eqps.get(i);
                        if (!wbo.getAttribute("parentId").toString().equalsIgnoreCase("0")) {
                            allEquipments.add(wbo);
                        }
                    }

                    servedPage = "/docs/reports/select_eqMaint_table.jsp";
                    request.setAttribute("EqReadReport", request.getParameter("EqReadReport").toString());
                    request.setAttribute("currentMode", "Ar");
                    request.setAttribute("data", allEquipments);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 75:
                    servedPage = "/docs/reports/eqMaint_Table_Report.jsp";
                    maintainableMgr = MaintainableMgr.getInstance();
                    scheduleMgr = ScheduleMgr.getInstance();
                    ConfigureMainTypeMgr configureMainTypeMgr = ConfigureMainTypeMgr.getInstance();
                    ScheduleTasksMgr scheduleTasksMgr = ScheduleTasksMgr.getInstance();
                    taskMgr = TaskMgr.getInstance();
                    ItemsMgr itemsMgr = ItemsMgr.getInstance();
                    localStoresItemsMgr = LocalStoresItemsMgr.getInstance();
                    maintenanceItemMgr = MaintenanceItemMgr.getInstance();

                    Vector tables = new Vector();
                    Vector scheduleParts = new Vector();
                    Vector scheduleTasks = new Vector();
                    Vector parts = new Vector();
                    Vector items = new Vector();
                    tempVec = new Vector();
                    equips = new Vector();
                    Hashtable hashtable = new Hashtable();
                    Hashtable tableItems = new Hashtable();
                    Hashtable tableParts = new Hashtable();
                    WebBusinessObject tableWbo = new WebBusinessObject();
                    WebBusinessObject partWbo = new WebBusinessObject();
                    WebBusinessObject scheduleTaskWbo = new WebBusinessObject();
                    WebBusinessObject schedulePartWbo = new WebBusinessObject();
                    equipmetWboVec = null;
                    String get = (String) request.getParameter("get");

                    if (get.equalsIgnoreCase("eq")) {
                        eqID = (String) request.getParameter("equipmentId");
                        if (!eqID.equalsIgnoreCase("") || eqID != null) {

                            try {
                                getEqId = maintainableMgr.getOnArbitraryKey(eqID, "key4");
                                //CHECK IF NOT VAILD EQUIPMENT ID
                                if (getEqId.size() <= 0) {
                                    maintainableMgr = MaintainableMgr.getInstance();
                                    allEquipments = new ArrayList();
                                    eqps = new Vector();
                                    eqps = maintainableMgr.getOnArbitraryDoubleKey("1", "key3", "0", "key5");
                                    wbo = new WebBusinessObject();

                                    for (int i = 0; i < eqps.size(); i++) {
                                        wbo = (WebBusinessObject) eqps.get(i);
                                        if (!wbo.getAttribute("parentId").toString().equalsIgnoreCase("0")) {
                                            allEquipments.add(wbo);
                                        }
                                    }

                                    request.setAttribute("status", "fail");
                                    servedPage = "/docs/reports/select_eqMaint_table.jsp";
                                    request.setAttribute("EqReadReport", request.getParameter("EqReadReport").toString());
                                    request.setAttribute("currentMode", "Ar");
                                    request.setAttribute("data", allEquipments);
                                    request.setAttribute("page", servedPage);
                                    this.forwardToServedPage(request, response);
                                    break;
                                }


                                tempWboForId = (WebBusinessObject) getEqId.get(0);
                                eqID = tempWboForId.getAttribute("id").toString();




                            } catch (SQLException ex) {
                                servedPage = "/docs/reports/select_eqMaint_table.jsp";
                                request.setAttribute("page", servedPage);
                                this.forwardToServedPage(request, response);
                                break;
                            } catch (Exception ex) {
                                logger.error(ex.getMessage());
                                servedPage = "/docs/reports/select_eqMaint_table.jsp";
                                request.setAttribute("page", servedPage);
                                this.forwardToServedPage(request, response);
                                break;
                            }
                        } else {
                            allEquipments = new ArrayList();
                            eqps = new Vector();
                            eqps = maintainableMgr.getOnArbitraryDoubleKey("1", "key3", "0", "key5");
                            wbo = new WebBusinessObject();
                            for (int i = 0; i < eqps.size(); i++) {
                                wbo = (WebBusinessObject) eqps.get(i);
                                if (!wbo.getAttribute("parentId").toString().equalsIgnoreCase("0")) {
                                    allEquipments.add(wbo);
                                }
                            }
                            request.setAttribute("status", "fail");
                            servedPage = "/docs/reports/select_eqMaint_table.jsp";
                            request.setAttribute("currentMode", "Ar");
                        }
                        tables = scheduleMgr.getOnArbitraryKey(eqID, "key2");
                        for (int m = 0; m < tables.size(); m++) {
                            items = new Vector();
                            parts = new Vector();
                            tableWbo = new WebBusinessObject();
                            scheduleParts = new Vector();
                            scheduleTasks = new Vector();

                            tableWbo = (WebBusinessObject) tables.get(m);
                            scheduleParts = configureMainTypeMgr.getConfigItemBySchedule(tableWbo.getAttribute("periodicID").toString());
                            scheduleTasks = scheduleTasksMgr.getOnArbitraryKey(tableWbo.getAttribute("periodicID").toString(), "key1");

                            for (int n = 0; n < scheduleTasks.size(); n++) {
                                taskWbo = new WebBusinessObject();
                                scheduleTaskWbo = new WebBusinessObject();
                                scheduleTaskWbo = (WebBusinessObject) scheduleTasks.get(n);
                                taskWbo = taskMgr.getOnSingleKey(scheduleTaskWbo.getAttribute("codeTask").toString());
                                items.add(taskWbo);
                            }
                            for (int n = 0; n < scheduleParts.size(); n++) {
                                partWbo = new WebBusinessObject();
                                schedulePartWbo = new WebBusinessObject();
                                schedulePartWbo = (WebBusinessObject) scheduleParts.get(n);
                                tempVec = itemsMgr.getOnArbitraryKey(schedulePartWbo.getAttribute("itemId").toString(), "key");
                                partWbo = (WebBusinessObject) tempVec.get(0);
                                parts.add(partWbo);
                            }
                            tableItems.put(tableWbo.getAttribute("periodicID").toString(), items);
                            tableParts.put(tableWbo.getAttribute("periodicID").toString(), parts);
                        }

                        request.setAttribute("tables", tables);
                        unitWbo = maintainableMgr.getOnSingleKey(eqID);
                        request.setAttribute("equipmentWbo", unitWbo);
                    } else {
                        equips = maintainableMgr.getOnArbitraryDoubleKey("1", "key3", "0", "key5");
                        for (int i = 0; i < equips.size(); i++) {
                            tables = new Vector();
                            unitWbo = new WebBusinessObject();
                            unitWbo = (WebBusinessObject) equips.get(i);
                            eqID = unitWbo.getAttribute("id").toString();
                            tables = scheduleMgr.getOnArbitraryKey(eqID, "key2");
                            hashtable.put(eqID, tables);
                            for (int m = 0; m < tables.size(); m++) {
                                items = new Vector();
                                parts = new Vector();
                                tableWbo = new WebBusinessObject();
                                scheduleParts = new Vector();
                                scheduleTasks = new Vector();

                                tableWbo = (WebBusinessObject) tables.get(m);
                                scheduleParts = configureMainTypeMgr.getConfigItemBySchedule(tableWbo.getAttribute("periodicID").toString());
                                scheduleTasks = scheduleTasksMgr.getOnArbitraryKey(tableWbo.getAttribute("periodicID").toString(), "key1");

                                for (int n = 0; n < scheduleTasks.size(); n++) {
                                    taskWbo = new WebBusinessObject();
                                    scheduleTaskWbo = new WebBusinessObject();
                                    scheduleTaskWbo = (WebBusinessObject) scheduleTasks.get(n);
                                    taskWbo = taskMgr.getOnSingleKey(scheduleTaskWbo.getAttribute("codeTask").toString());
                                    items.add(taskWbo);
                                }
                                for (int n = 0; n < scheduleParts.size(); n++) {
                                    partWbo = new WebBusinessObject();
                                    schedulePartWbo = new WebBusinessObject();
                                    tempVec = new Vector();

                                    schedulePartWbo = (WebBusinessObject) scheduleParts.get(n);
                                    tempVec = itemsMgr.getOnArbitraryKey(schedulePartWbo.getAttribute("itemId").toString(), "key");
                                    partWbo = (WebBusinessObject) tempVec.get(0);
                                    parts.add(partWbo);
                                }
                                tableItems.put(tableWbo.getAttribute("periodicID").toString(), items);
                                tableParts.put(tableWbo.getAttribute("periodicID").toString(), parts);
                            }
                        }

                    }
                    request.setAttribute("tableItems", tableItems);
                    request.setAttribute("tableParts", tableParts);
                    request.setAttribute("allEqsTables", hashtable);
                    request.setAttribute("allEqps", equips);
                    this.forward(servedPage, request, response);

                    break;

                case 76:
                    maintainableMgr = MaintainableMgr.getInstance();
                    allEquipments = new ArrayList();
                    eqps = new Vector();
                    eqps = maintainableMgr.getOnArbitraryDoubleKey("1", "key3", "0", "key5");
                    wbo = new WebBusinessObject();

                    for (int i = 0; i < eqps.size(); i++) {
                        wbo = (WebBusinessObject) eqps.get(i);
                        if (!wbo.getAttribute("parentId").toString().equalsIgnoreCase("0")) {
                            allEquipments.add(wbo);
                        }
                    }

                    servedPage = "/docs/reports/select_eqJO_report.jsp";
                    request.setAttribute("currentMode", "Ar");
                    request.setAttribute("schedule", request.getParameter("schedule").toString());
                    request.setAttribute("data", allEquipments);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 77:
                    maintainableMgr = MaintainableMgr.getInstance();
                    equipmetWboVec = null;
                    String schedule = request.getParameter("schedule");

                    eqID = (String) request.getParameter("equipmentId");
                    getEqId = maintainableMgr.getOnArbitraryKey(eqID, "key4");
                    if (getEqId.size() > 0) {
                        tempWboForId = (WebBusinessObject) getEqId.get(0);
                        eqID = tempWboForId.getAttribute("id").toString();
                        averageUnitMgr = AverageUnitMgr.getInstance();
                        eqReading = new Vector();
                        readingWbo = new WebBusinessObject();
                        eqReading = averageUnitMgr.getOnArbitraryKey(eqID, "key1");

                        issueMgr = IssueMgr.getInstance();
                        String bDate = request.getParameter("beginDate");
                        String eDate = request.getParameter("endDate");
//                        String []bDateArr=new String [3];
//                        String []eDateArr=new String [3];
//                        bDateArr=bDate.split("/");
//                        eDateArr=eDate.split("/");
//                        int bYear=Integer.parseInt(bDateArr[2]);
//                        int bMonth=Integer.parseInt(bDateArr[0]);
//                        int bDay=Integer.parseInt(bDateArr[1]);
//
//                        eYear=Integer.parseInt(eDateArr[2]);
//                        eMonth=Integer.parseInt(eDateArr[0]);
//                        eDay=Integer.parseInt(eDateArr[1]);
//
//                        java.sql.Date beginDate=new java.sql.Date(bYear-1900,bMonth-1,bDay);
//                        java.sql.Date endDate=new java.sql.Date(eYear-1900,eMonth-1,eDay);

                        dateParser = new DateParser();
                        java.sql.Date beginDate = dateParser.formatSqlDate(bDate);
                        java.sql.Date endDate = dateParser.formatSqlDate(eDate);

                        Vector equipsIssues = issueMgr.getEqIssuesInRange(beginDate, endDate, eqID);

                        issueTasksMgr = IssueTasksMgr.getInstance();
                        taskMgr = TaskMgr.getInstance();
                        taskDetails = new Vector();
                        issueTasksDetails = new Vector();
                        taskWbo = new WebBusinessObject();
                        tasksHashTable = new Hashtable();
                        wbo = new WebBusinessObject();
                        issueTaskWbo = new WebBusinessObject();
                        taskId = null;
                        issueId = null;
                        String unit_schedule_Id = "";
                        WebBusinessObject unitScheduleWbo = new WebBusinessObject();
                        unitScheduleMgr = UnitScheduleMgr.getInstance();
                        //loop to get maintainance items for each issue for eq
                        for (int i = 0; i < equipsIssues.size(); i++) {
                            issueTasksDetails = new Vector();
                            wbo = new WebBusinessObject();
                            issueId = "";
                            wbo = (WebBusinessObject) equipsIssues.get(i);
                            issueId = wbo.getAttribute("id").toString();
                            unit_schedule_Id = wbo.getAttribute("unitScheduleID").toString();
                            unitScheduleWbo = unitScheduleMgr.getOnSingleKey(unit_schedule_Id);
                            wbo.setAttribute("unitScheduleTitle", unitScheduleWbo.getAttribute("maintenanceTitle").toString());

                            //get issue tasks
                            issueTasks = issueTasksMgr.getOnArbitraryKey(issueId, "key1");
                            for (int x = 0; x < issueTasks.size(); x++) {
                                taskId = "";
                                taskWbo = new WebBusinessObject();
                                issueTaskWbo = new WebBusinessObject();
                                issueTaskWbo = (WebBusinessObject) issueTasks.get(x);
                                taskId = issueTaskWbo.getAttribute("codeTask").toString();
                                //get task record
                                taskWbo = taskMgr.getOnSingleKey(taskId);
                                issueTasksDetails.add(taskWbo);
                            }
                            tasksHashTable.put(issueId, issueTasksDetails);
                        }
                        quantifiedMntenceMgr = QuantifiedMntenceMgr.getInstance();
                        maintenanceItemMgr = MaintenanceItemMgr.getInstance();
                        localStoresItemsMgr = LocalStoresItemsMgr.getInstance();
                        issueStoreParts = new Hashtable();
                        quantifiedItems = new Vector();
                        loaclitems = new Vector();
                        unitScheduleId = null;
                        quanitifiedWbo = new WebBusinessObject();
                        item = new WebBusinessObject();
                        for (int i = 0; i < equipsIssues.size(); i++) {
                            wbo = new WebBusinessObject();
                            quantifiedItems = new Vector();
                            issueId = "";
                            unitScheduleId = "";
                            quantifiedItems = new Vector();
                            wbo = (WebBusinessObject) equipsIssues.get(i);
                            unitScheduleId = wbo.getAttribute("unitScheduleID").toString();
                            issueId = wbo.getAttribute("id").toString();
                            quantifiedItems = quantifiedMntenceMgr.getOnArbitraryKey(unitScheduleId, "key1");
                            for (int n = 0; n < quantifiedItems.size(); n++) {
                                quanitifiedWbo = new WebBusinessObject();
                                quanitifiedWbo = (WebBusinessObject) quantifiedItems.get(n);
                                String itemID = (String) quanitifiedWbo.getAttribute("itemId");
                                String is_Direct = (String) quanitifiedWbo.getAttribute("isDirectPrch");
                                if (is_Direct.equals("0")) {
                                    item = new WebBusinessObject();
                                    item = maintenanceItemMgr.getOnSingleKey(itemID);
                                    quanitifiedWbo.setAttribute("itemCode", item.getAttribute("itemCode"));
                                    quanitifiedWbo.setAttribute("itemDscrptn", item.getAttribute("itemDscrptn"));
                                } else {
                                    loaclitems = new Vector();
                                    loaclitems = localStoresItemsMgr.getOnArbitraryKey(itemID, "key1");
                                    for (int x = 0; x < loaclitems.size(); x++) {
                                        item = new WebBusinessObject();
                                        item = (WebBusinessObject) loaclitems.get(x);
                                        quanitifiedWbo.setAttribute("itemCode", item.getAttribute("itemCode"));
                                        quanitifiedWbo.setAttribute("itemDscrptn", item.getAttribute("itemName"));
                                    }
                                }
                            }
                            issueStoreParts.put(issueId, quantifiedItems);
                        }

                        maintainableMgr = MaintainableMgr.getInstance();
                        unitWbo = maintainableMgr.getOnSingleKey(eqID);
                        if (eqReading.size() > 0) {
                            readingWbo = (WebBusinessObject) eqReading.get(0);
                            unitWbo.setAttribute("lastReading", (String) readingWbo.getAttribute("acual_Reading"));
                            unitWbo.setAttribute("lastReadingDate", readingWbo.getAttribute("entry_Time").toString());
                        }

                        if (schedule.equalsIgnoreCase("no")) {
                            servedPage = "/docs/reports/eqJO_intervalTime_Report.jsp";
                        } else {
                            servedPage = "/docs/reports/eqJO_Report.jsp";
                        }

                        request.setAttribute("bDate", bDate);
                        request.setAttribute("eDate", eDate);
                        request.setAttribute("equipIssues", equipsIssues);
                        request.setAttribute("issueTasks", tasksHashTable);
                        request.setAttribute("issueParts", issueStoreParts);
                        request.setAttribute("equipmentWbo", unitWbo);

                        this.forward(servedPage, request, response);
                    } else {
                        maintainableMgr = MaintainableMgr.getInstance();
                        allEquipments = new ArrayList();
                        eqps = new Vector();
                        eqps = maintainableMgr.getOnArbitraryDoubleKey("1", "key3", "0", "key5");
                        wbo = new WebBusinessObject();

                        for (int i = 0; i < eqps.size(); i++) {
                            wbo = (WebBusinessObject) eqps.get(i);
                            if (!wbo.getAttribute("parentId").toString().equalsIgnoreCase("0")) {
                                allEquipments.add(wbo);
                            }
                        }

                        servedPage = "/docs/reports/select_eqJO_report.jsp";
                        request.setAttribute("currentMode", "Ar");
                        request.setAttribute("status", "fail");
                        request.setAttribute("schedule", request.getParameter("schedule").toString());
                        request.setAttribute("data", allEquipments);
                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);

                    }
                    break;

                case 78:
                    maintainableMgr = MaintainableMgr.getInstance();
                    equipmetWboVec = null;
                    get = (String) request.getParameter("get");
                    averageUnitMgr = AverageUnitMgr.getInstance();
                    readingWbo = new WebBusinessObject();
                    Vector readingVec = new Vector();
                    unitWbo = new WebBusinessObject();
                    WebBusinessObject empWbo = new WebBusinessObject();
                    LiteWebBusinessObject empLiteWbo = new LiteWebBusinessObject();
                    empBasicMgr = EmpBasicMgr.getInstance();
                    EmployeeMgr employeeMgr = EmployeeMgr.getInstance();
                    equips = new Vector();
                    String empName = "";

                    if (get.equalsIgnoreCase("eq")) {
                        eqID = (String) request.getParameter("equipmentId");
                        if (!eqID.equalsIgnoreCase("") || eqID != null) {

                            try {
                                getEqId = maintainableMgr.getOnArbitraryKey(eqID, "key4");
                                tempWboForId = (WebBusinessObject) getEqId.get(0);
                                eqID = tempWboForId.getAttribute("id").toString();
                            } catch (SQLException ex) {
                                servedPage = "/docs/reports/select_eqMaint_table.jsp";
                                request.setAttribute("page", servedPage);
                                this.forwardToServedPage(request, response);
                                break;
                            } catch (Exception ex) {
                                logger.error(ex.getMessage());
                                servedPage = "/docs/reports/select_eqMaint_table.jsp";
                                request.setAttribute("page", servedPage);
                                this.forwardToServedPage(request, response);
                                break;
                            }
                            unitWbo = maintainableMgr.getOnSingleKey(eqID);
                            readingVec = averageUnitMgr.getOnArbitraryKey(eqID, "key1");
                            empWbo = empBasicMgr.getOnSingleKey(unitWbo.getAttribute("empID").toString());

                            if (empWbo != null) {
                                empName = empWbo.getAttribute("empName").toString();
                            } else {
                                empLiteWbo = employeeMgr.getOnSingleKey(unitWbo.getAttribute("empID").toString());
                                if (empLiteWbo != null) {
                                    empName = empLiteWbo.getAttribute("empName").toString();
                                } else {
                                    empName = "No User";
                                }
                            }
                            unitWbo.setAttribute("empName", empName);
                            if (readingVec.size() > 0) {
                                readingWbo = (WebBusinessObject) readingVec.get(0);
                                unitWbo.setAttribute("lastRaeding", readingWbo.getAttribute("acual_Reading").toString());
                                unitWbo.setAttribute("lastRaedingDate", readingWbo.getAttribute("entry_Time").toString());
                            }


                        } else {
                            allEquipments = new ArrayList();
                            eqps = new Vector();
                            eqps = maintainableMgr.getOnArbitraryDoubleKey("1", "key3", "0", "key5");
                            wbo = new WebBusinessObject();
                            for (int i = 0; i < eqps.size(); i++) {
                                wbo = (WebBusinessObject) eqps.get(i);
                                if (!wbo.getAttribute("parentId").toString().equalsIgnoreCase("0")) {
                                    allEquipments.add(wbo);
                                }
                            }

                            servedPage = "/docs/reports/select_eqMaint_table.jsp";
                            request.setAttribute("currentMode", "Ar");
                        }
                        equips.add(unitWbo);
                    } else {

                        equips = maintainableMgr.getOnArbitraryDoubleKey("1", "key3", "0", "key5");
                        for (int i = 0; i < equips.size(); i++) {
                            tables = new Vector();
                            unitWbo = new WebBusinessObject();
                            unitWbo = (WebBusinessObject) equips.get(i);
                            eqID = unitWbo.getAttribute("id").toString();
                            readingVec = new Vector();
                            readingWbo = new WebBusinessObject();
                            empWbo = new WebBusinessObject();
                            empLiteWbo = new LiteWebBusinessObject();
                            readingVec = averageUnitMgr.getOnArbitraryKey(eqID, "key1");
                            empWbo = empBasicMgr.getOnSingleKey(unitWbo.getAttribute("empID").toString());
                            empName = "";
                            if (empWbo != null) {
                                empName = empWbo.getAttribute("empName").toString();
                            } else {
                                empLiteWbo = employeeMgr.getOnSingleKey(unitWbo.getAttribute("empID").toString());
                                if (empLiteWbo != null) {
                                    empName = empLiteWbo.getAttribute("empName").toString();
                                }
                            }
                            unitWbo.setAttribute("empName", empName);
                            if (readingVec.size() > 0) {
                                readingWbo = (WebBusinessObject) readingVec.get(0);
                                unitWbo.setAttribute("lastRaeding", readingWbo.getAttribute("acual_Reading").toString());
                                unitWbo.setAttribute("lastRaedingDate", readingWbo.getAttribute("entry_Time").toString());
                            }
                        }

                    }

                    request.setAttribute("allEqps", equips);
                    servedPage = "/docs/reports/eq_Reading_Report.jsp";
                    this.forward(servedPage, request, response);

                    break;

                case 79:
                    servedPage = "/docs/reports/maint_Items_Report.jsp";
                    issueMgr = IssueMgr.getInstance();
                    Vector statisticsItems = new Vector();
                    issueTasksMgr = IssueTasksMgr.getInstance();
                    taskMgr = TaskMgr.getInstance();
                    ArrayList allTasks = taskMgr.getCashedTableAsBusObjects();
                    Vector tasks = new Vector();
                    taskWbo = new WebBusinessObject();
                    taskId = "";
                    count = 0;
                    String allValues = new String();
                    for (int i = 0; i < allTasks.size(); i++) {
                        count = 0;
                        taskWbo = new WebBusinessObject();
                        taskWbo = (WebBusinessObject) allTasks.get(i);
                        taskId = taskWbo.getAttribute("id").toString();
                        count = issueTasksMgr.CountMaintenanceItems(taskId);
                        allValues += "" + count + "#";
                        taskWbo.setAttribute("count", "" + count);
                        taskWbo.setAttribute("Count", count);
                        Hashtable test = taskWbo.getContents();
                        tasks.add(taskWbo);
                        /*statisticsItems.addElement(new String(taskId));
                        statisticsItems.addElement(new String(allValues));
                        statisticsItems.addElement(new Integer(count));*/

                    }
                    allValues = allValues.substring(0, allValues.length() - 1);
                    request.setAttribute("allValues", allValues);
                    request.setAttribute("tasks", tasks);

                    Map params = new HashMap();
                    params.put("title", "Tasks");
                    // create and open PDF report in browser
                    ServletContext context = getServletConfig().getServletContext();
                    tasks.setSize(50);
                    Tools.createPdfReport("MaintenanceItemsStatistics", params, tasks, context, response, request);

                    //   request.setAttribute("page", servedPage);
                    this.forward(servedPage, request, response);
                    break;

                case 80:
                    maintainableMgr = MaintainableMgr.getInstance();
                    allEquipments = new ArrayList();
                    eqps = new Vector();
                    eqps = maintainableMgr.getOnArbitraryDoubleKey("1", "key3", "0", "key5");
                    wbo = new WebBusinessObject();

                    for (int i = 0; i < eqps.size(); i++) {
                        wbo = (WebBusinessObject) eqps.get(i);
                        if (!wbo.getAttribute("parentId").toString().equalsIgnoreCase("0")) {
                            allEquipments.add(wbo);
                        }
                    }

                    servedPage = "/docs/reports/select_all_eqStatus_report.jsp";
                    request.setAttribute("currentMode", "Ar");
                    request.setAttribute("data", allEquipments);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;


                case 81:
                    //get all changes in eq Status like working in date then outworking and So on.
                    maintainableMgr = MaintainableMgr.getInstance();
                    Vector allEqStatus = new Vector();
                    WebBusinessObject eqStatusWbo = null;
                    EquipmentStatusMgr equipmentStatusMgr = EquipmentStatusMgr.getInstance();
                    eqID = (String) request.getParameter("equipmentId");
                    getEqId = maintainableMgr.getOnArbitraryKey(eqID, "key4");
                    if (getEqId.size() > 0) {

                        tempWboForId = (WebBusinessObject) getEqId.get(0);
                        eqID = tempWboForId.getAttribute("id").toString();

                        allEqStatus = equipmentStatusMgr.getOnArbitraryKeyOrdered(eqID, "key1", "key2");

                        for (int i = 0; i < allEqStatus.size(); i++) {
                            eqStatusWbo = new WebBusinessObject();
                            eqStatusWbo = (WebBusinessObject) allEqStatus.get(i);
                            if (eqStatusWbo.getAttribute("stateID").toString().equalsIgnoreCase("1")) {
                                eqStatusWbo.setAttribute("stat", "working");
                            } else {
                                eqStatusWbo.setAttribute("stat", "Out Of working");
                            }
                            eqStatusWbo.setAttribute("unitName", tempWboForId.getAttribute("unitName").toString());
                        }

                        servedPage = "/docs/reports/eq_allStatus_Report.jsp";
                        request.setAttribute("eqWbo", tempWboForId);
                        request.setAttribute("allEqStatus", allEqStatus);
                        //  request.setAttribute("page", servedPage);
                        this.forward(servedPage, request, response);
                    } else {
                        maintainableMgr = MaintainableMgr.getInstance();
                        allEquipments = new ArrayList();
                        eqps = new Vector();
                        eqps = maintainableMgr.getOnArbitraryDoubleKey("1", "key3", "0", "key5");
                        wbo = new WebBusinessObject();

                        for (int i = 0; i < eqps.size(); i++) {
                            wbo = (WebBusinessObject) eqps.get(i);
                            if (!wbo.getAttribute("parentId").toString().equalsIgnoreCase("0")) {
                                allEquipments.add(wbo);
                            }
                        }

                        request.setAttribute("status", "fail");
                        servedPage = "/docs/reports/select_all_eqStatus_report.jsp";
                        request.setAttribute("currentMode", "Ar");
                        request.setAttribute("data", allEquipments);
                        request.setAttribute("page", servedPage);
                        this.forwardToServedPage(request, response);
                    }
                    break;

                case 82:
                    maintainableMgr = MaintainableMgr.getInstance();
                    allEqStatus = new Vector();
                    equipmentStatusMgr = EquipmentStatusMgr.getInstance();
                    Vector outOfWorkingEqps = maintainableMgr.getEqpsOutOfWorking();
                    eqWbo = new WebBusinessObject();
                    eqID = "";
                    eqStatusWbo = new WebBusinessObject();
                    for (int i = 0; i < outOfWorkingEqps.size(); i++) {
                        eqWbo = new WebBusinessObject();
                        eqWbo = (WebBusinessObject) outOfWorkingEqps.get(i);
                        eqID = eqWbo.getAttribute("id").toString();
                        eqStatusWbo = equipmentStatusMgr.getLastStatus(eqID);
                        eqWbo.setAttribute("beginStatusDate", eqStatusWbo.getAttribute("beginDate").toString());
                        eqWbo.setAttribute("statusNote", eqStatusWbo.getAttribute("note").toString());
                    }

                    request.setAttribute("outOfWorkingEqps", outOfWorkingEqps);
                    servedPage = "/docs/reports/outOfWorking_Eqps_Report.jsp";
                    //    request.setAttribute("page", servedPage);
                    this.forward(servedPage, request, response);

                    break;

                case 83:
                    ProductionLineMgr productionLineMgr = ProductionLineMgr.getInstance();
                    ArrayList pLines = productionLineMgr.getCashedTableAsBusObjects();

                    request.setAttribute("currentMode", "Ar");
                    request.setAttribute("pLines", pLines);
                    servedPage = "/docs/reports/get_pLine_Form_report.jsp";
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 84:
                    maintainableMgr = MaintainableMgr.getInstance();
                    equipments = new Vector();
                    productLineId = (String) request.getParameter("productLineId");
                    productionLineMgr = ProductionLineMgr.getInstance();
                    WebBusinessObject pLineWbo = (WebBusinessObject) productionLineMgr.getOnSingleKey(productLineId);

                    options = null;
                    options = (String[]) request.getParameterValues("equipmentData");

                    query = "select ";
                    if (options == null || options.length <= 0) {
                        query += "UNIT_NAME ,ID";
                    } else {
                        query += "UNIT_NAME ,ID ,";
                        for (int i = 0; i < options.length; i++) {
                            query += options[i] + ",";
                        }
                    }

                    query = query.trim().substring(0, query.length() - 1);
                    query += " FROM maintainable_unit WHERE PRODUCTION_LINE = ? and IS_DELETED = '0' order by UNIT_NAME ";

                    equipments = maintainableMgr.getEquipmentRecord(query, productLineId);

                    servedPage = "/docs/reports/pLine_Eqps_Report.jsp";
                    request.setAttribute("pLineWbo", pLineWbo);
                    request.setAttribute("items", options);
                    request.setAttribute("equipments", equipments);
                    this.forward(servedPage, request, response);
                    break;

                case 85:
                    maintainableMgr = MaintainableMgr.getInstance();
                    allEqStatus = new Vector();
                    equipmentStatusMgr = EquipmentStatusMgr.getInstance();
                    issueMgr = IssueMgr.getInstance();
                    Vector outOfWorkingEqpsWithOutJo = new Vector();
                    Vector equipsAssigndJo = new Vector();
                    equips = new Vector();
                    equips = maintainableMgr.getEqpsOutOfWorking();
                    eqID = "";
                    for (int i = 0; i < equips.size(); i++) {
                        id = "";
                        eqWbo = new WebBusinessObject();
                        eqStatusWbo = new WebBusinessObject();
                        equipsAssigndJo = new Vector();
                        eqWbo = (WebBusinessObject) equips.get(i);
                        eqID = eqWbo.getAttribute("id").toString();
                        equipsAssigndJo = issueMgr.getOnArbitraryDoubleKey(eqID, "key6", "Assigned", "key7");

                        if (equipsAssigndJo.size() <= 0) {
                            eqStatusWbo = equipmentStatusMgr.getLastStatus(eqID);
                            eqWbo.setAttribute("beginStatusDate", eqStatusWbo.getAttribute("beginDate").toString());
                            eqWbo.setAttribute("statusNote", eqStatusWbo.getAttribute("note").toString());
                            outOfWorkingEqpsWithOutJo.add(eqWbo);
                        }
                    }

                    request.setAttribute("outOfWorkingEqpsNoJO", outOfWorkingEqpsWithOutJo);
                    servedPage = "/docs/reports/outOfWorking_Eqps_WithOutJO_Report.jsp";
                    //    request.setAttribute("page", servedPage);
                    this.forward(servedPage, request, response);

                    break;

                case 86:
//                    eqps = new Vector();
//                    excelCreator = new ExcelCreator();
//                    com.maintenance.common.AppConstants headersData = new AppConstants();
//                    Hashtable equipmentHeaders = headersData.getEquipmentHeaders();
//
//                    eqps = (Vector) request.getSession().getAttribute("data");
//                    String[] itemsData = (String[]) request.getSession().getAttribute("items");
//
//                    String[] headers = new String[itemsData.length + 1];
//                    String[] attributes = new String[itemsData.length + 1];
//                    String[] dataTypes = new String[itemsData.length + 1];
//                    headers[0] = (String) equipmentHeaders.get("EnUNIT_NAME");
//                    attributes[0] = "unitName";
//                    dataTypes[0] = "String";
//                    String headerItem = "";
//                    for (int i = 0; i < itemsData.length; i++) {
//                        headers[i + 1] = (String) equipmentHeaders.get("En" + (String) itemsData[i]);
//                        attributes[i + 1] = (String) equipmentHeaders.get("Att" + (String) itemsData[i]);
//                        dataTypes[i + 1] = "String";
//                    }
//
//                    workBook = excelCreator.createExcelFile(headers, attributes, dataTypes, eqps, 0);
//
//                    response.setHeader("Content-Disposition",
//                            "attachment; filename=\"" + "Equipments_Status.xls");
//                    workBook.write(response.getOutputStream());
//
//                    response.getOutputStream().flush();
//                    response.getOutputStream().close();
//                    break;

                case 87:
//                    ExcelCreator excelCreator = new ExcelCreator();
//                    Vector categoriesVec = (Vector) request.getSession().getAttribute("data");
//
//                    attributes = (String[]) request.getSession().getAttribute("attributes");
//                    headers = (String[]) request.getSession().getAttribute("headers");
//                    dataTypes = new String[attributes.length];
//
//                    for (int i = 0; i < headers.length; i++) {
//                        dataTypes[i] = "String";
//                    }
//
//                    workBook = excelCreator.createExcelFile(headers, attributes, dataTypes, categoriesVec, 0);
//
//                    response.setHeader("Content-Disposition",
//                            "attachment; filename=\"" + "List_Categories.xls");
//                    workBook.write(response.getOutputStream());
//
//                    response.getOutputStream().flush();
//                    response.getOutputStream().close();
//                    break;

                case 88:
                    equipments = new Vector();
                    maintenableUnit = MaintainableMgr.getInstance();
                    maintenableUnit.cashData();
                    mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();
                    Vector mainCategoriesVec = new Vector();
                    Hashtable catEqps = new Hashtable();
                    maintainableMgr = MaintainableMgr.getInstance();
                    mainCatWbo = new WebBusinessObject();
                    mainCatId = "";
                    String total = "";

                    //main categories without equipments that work as Eqps
                    mainCategoriesVec = mainCategoryTypeMgr.getCashedTable();

                    for (int i = 0; i < mainCategoriesVec.size(); i++) {
                        mainCatWbo = new WebBusinessObject();
                        mainCatId = "";
                        mainCatWbo = (WebBusinessObject) mainCategoriesVec.get(i);
                        mainCatId = mainCatWbo.getAttribute("id").toString();
                        total = maintainableMgr.getTotalEquipmentByMainCat(mainCatId);
                        catEqps.put(mainCatId, total);
                    }

                    servedPage = "/docs/newEquipment/eqps_By_MainType_List.jsp";

                    request.setAttribute("catEqps", catEqps);
                    request.setAttribute("mainCatVec", mainCategoriesVec);

                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 89:
                    count = 0;
                    backTo = "EquipmentServlet?op=EquipmentsByMainCat";
                    url = (String) request.getParameter("url");
                    tempcount = (String) request.getParameter("count");
                    if (tempcount != null) {
                        count = Integer.parseInt(tempcount);
                    }

                    maintainableMgr = MaintainableMgr.getInstance();
                    mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();
                    Vector eqpsForCat = new Vector();
                    category = new Vector();
                    mainCatId = (String) request.getParameter("mainCatId");
                    mainCatWbo = new WebBusinessObject();
                    mainCatWbo = mainCategoryTypeMgr.getOnSingleKey(mainCatId);

                    eqpsForCat = maintainableMgr.getAllEqpsForMainCat(mainCatId);

                    servedPage = "/docs/newEquipment/equipment_list.jsp";

//                    index=(count+1)*10;
                    index = (count + 1) * eqpsForCat.size();
                    if (eqpsForCat.size() < index) {
                        index = eqpsForCat.size();
                    }
                    id = "";
                    checkattched = new Vector();
                    supplementMgr = SupplementMgr.getInstance();
                    for (int i = count * 10; i < index; i++) {
                        wbo = (WebBusinessObject) eqpsForCat.get(i);
                        id = (String) wbo.getAttribute("id");
                        checkattched = supplementMgr.search(id);
                        if (checkattched.size() > 0) {
                            wbo.setAttribute("nowStatus", "attached");
                        } else {
                            checkattched = supplementMgr.searchAllowedEqps(id);
                            if (checkattched.size() > 0) {
                                wbo.setAttribute("nowStatus", "attached");
                            } else {
                                wbo.setAttribute("nowStatus", "notattached");
                            }
                        }
                        category.add(wbo);
                    }

                    noOfLinks = eqpsForCat.size() / 10f;
                    temp = "" + noOfLinks;
                    intNo = Integer.parseInt(temp.substring(temp.indexOf(".") + 1, temp.length()));
                    links = (int) noOfLinks;
                    if (intNo > 0) {
                        links++;
                    }
                    if (links == 1) {
                        links = 0;
                    }

                    fullUrl = url + "&mainCatId=" + mainCatId;
                    lastFilter = "EquipmentServlet?op=viewMainCatEqps&count=0&mainCatId=" + mainCatId;
                    session.setAttribute("lastFilter", lastFilter);

                    topMenu = new Hashtable();
                    tempVec = new Vector();
                    topMenu = (Hashtable) request.getSession().getAttribute("topMenu");
                    if (topMenu != null && topMenu.size() > 0) {
                        tempVec = new Vector();
                        tempVec.add("lastFilter");
                        tempVec.add(lastFilter);
                        topMenu.put("lastFilter", tempVec);
                    } else {
                        topMenu = new Hashtable();
                        topMenu.put("jobOrder", new Vector());
                        topMenu.put("maintItem", new Vector());
                        topMenu.put("schedule", new Vector());
                        topMenu.put("equipment", new Vector());
                        tempVec = new Vector();
                        tempVec.add("lastFilter");
                        tempVec.add(lastFilter);
                        topMenu.put("lastFilter", tempVec);

                    }

                    request.getSession().setAttribute("topMenu", topMenu);

                    request.setAttribute("count", "" + count);
                    request.setAttribute("noOfLinks", "" + links);
                    request.setAttribute("categoryName", mainCatWbo.getAttribute("typeName").toString());
                    request.setAttribute("fullUrl", fullUrl);
                    request.setAttribute("url", url);
                    request.setAttribute("backTo", backTo);
                    request.setAttribute("data", category);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

//                case 90:
//                    empBasicMgr = EmpBasicMgr.getInstance();
//                    servedPage = "/docs/newEquipment/new_simple_equipment.jsp";
//                    equipBase = request.getParameter("base");
//                    EqpSequenceMgr eqpSequenceMgr=EqpSequenceMgr.getInstance();
//                    eqpSequenceMgr.updateSequence();
//                    String sequence=eqpSequenceMgr.getSequence();
//
//                    maintainableMgr = MaintainableMgr.getInstance();
//                    categoryList = new ArrayList();
////                    categoryList=parentUnitMgr.getCashedTableAsBusObjects();
//                    categoryTemp=new Vector();
//                    categoryTemp = maintainableMgr.getOnArbitraryKey("0","key3");
//                    categoryList = new ArrayList();
//                    for (int i = 0; i < categoryTemp.size(); i++) {
//                        wbo = (WebBusinessObject) categoryTemp.get(i);
//                        if (wbo.getAttribute("isMaintainable").toString().equalsIgnoreCase("0")) {
//                            wbo.setAttribute("parentName",wbo.getAttribute("unitName").toString());
//                            wbo.setAttribute("parentId",wbo.getAttribute("id").toString());
//                            categoryList.add(wbo);
//                        }
//                    }
//
//                    maintainableMgr.executeProcedureMachine("txt");
//                    fixedAssetsMachineMgr.cashData();
//
//                    request.setAttribute("listWorkers", empBasicMgr.getCashedTableAsBusObjects());
//                    request.setAttribute("base", equipBase);
//                    request.setAttribute("eqpSequence", sequence);
//                    request.setAttribute("categoryList", categoryList);
//                    request.setAttribute("page", servedPage);
//                    this.forwardToServedPage(request, response);
//                    break;

                case 91:
                    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
                    String projectType = metaMgr.getProjectType();
                    String subGroupId = null;
                    String subGroupName = null;
                    String groupId = null;
                    String groupName = null;

                    String erpFlag = null;
                    empBasicMgr = EmpBasicMgr.getInstance();
                    loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                    userId = loggedUser.getAttribute("userId").toString();
                    userHome = (String) loggedUser.getAttribute("userHome");
                    imageDirPath = getServletContext().getRealPath("/images");
                    userImageDir = imageDirPath + "/" + userHome;
                    randome = UniqueIDGen.getNextID();
                    len = randome.length();
                    randFileName = new String("ran" + randome.substring(5, len) + ".jpeg");
                    RIPath = userImageDir + "/" + randFileName;
                    userHome = (String) loggedUser.getAttribute("userHome");
                    userImageDir = imageDirPath + "/" + userHome;
                    userBackendHome = web_inf_path + "/usr/" + userHome + "/";
                    File usrDir = new File(userBackendHome);
                    usrDir = new File(userBackendHome);
                    String[] usrDirContents = usrDir.list();
                    DocViewerFileRenamePolicy ourPolicy = new DocViewerFileRenamePolicy();


                    now = timenow();
                    ourPolicy.setDesiredFileExt("jpg");

                    File oldFile = new File(userBackendHome + ourPolicy.getFileName());
                    oldFile.delete();


                    try {
                        mpr = new MultipartRequest(request, userBackendHome, 5 * 1024 * 1024, "UTF-8", ourPolicy);
                    } catch (IncorrectFileType e) {
                    }

                    /////////////////Fleet Update Code////////
                    mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();
                    WebBusinessObject mainCategoryTypeWbo = new WebBusinessObject();
                    WebBusinessObject mainBrandWbo = new WebBusinessObject();
                    if (projectType.equals("fleet") && mpr.getParameter("fixedEqp") != null && !mpr.getParameter("fixedEqp").equals("")) {
                        standAlone = (String) mpr.getParameter("standAlone");
                        departType = "NON";
                        try{
                            departType = (String) request.getParameter("departType");
                            if(departType == null || departType.equalsIgnoreCase("")){
                                departType = "NON";
                            }
                        }catch(Exception ex){
                            departType = "NON";
                        }
                        subGroupId = (String) mpr.getParameter("subGroupId");
                        subGroupName = (String) mpr.getParameter("subGroupName");
                        groupId = (String) mpr.getParameter("groupId");
                        groupName = (String) mpr.getParameter("groupName");
                        mainCategoryTypeWbo = mainCategoryTypeMgr.getOnSingleKey(groupId);
                        if (mainCategoryTypeWbo != null && !mainCategoryTypeWbo.equals("")) {
                            groupId = (String) mpr.getParameter("groupId");
                            groupName = (String) mpr.getParameter("groupName");
                        } else {
                            if (mainCategoryTypeMgr.saveAssetsGroup(groupId, groupName, groupName, "Assets", "0", standAlone, departType, session)) {
                                request.setAttribute("status", "ok");
                            } else {
                                request.setAttribute("status", "fail");
                            }

                        }
                        /////////////////////////
                        mainCat = groupId;

                        now = timenow();
                        flag = "parent";

                        wbo = null;
                        ht = new Hashtable();
                        unitID = subGroupId;
                        //maintenable unit data
                        ht.put("id", unitID);
                        ht.put("parentId", "0");
                        ht.put("unitLevel", "0");
                        ht.put("unitNo", unitID);
                        ht.put("engineNo", "0");
                        ht.put("modelNo", "NON");
                        ht.put("serialNo", "NON");
                        ht.put("unitName", subGroupName);
                        ht.put("manufacturer", "NON");
                        ht.put("location", mpr.getParameter("locations"));
                        ht.put("dept", mpr.getParameter("depts"));
                        ht.put("status", "NON");
                        String empId = (String) mpr.getParameter("AuthEmp");
                        WebBusinessObject wboEmp = new WebBusinessObject();
                        if (empId != null && !empId.equalsIgnoreCase("")) {
                            wboEmp = empBasicMgr.getOnSingleKey(empId);
                            empName = wboEmp.getAttribute("empName").toString();
                        } else {
                            empId = "";
                            empName = "";
                        }
                        ht.put("empID", empId);
                        ht.put("isMaintainable", new Integer(0));
                        ht.put("noOfHours", new Integer(0));
                        ht.put("desc", subGroupName);
                        ht.put("rateType", "NON");
                        ht.put("opType", "0");
                        ht.put("mainCat", mainCat);
                        ht.put("equipID", unitID);

                        ht.put("opeartionType", "NON");
                        ht.put("average", new Integer(0));
                        ht.put("isStandalone", "0");
                        maintainableMgr = MaintainableMgr.getInstance();
                        mainBrandWbo = (WebBusinessObject) maintainableMgr.getOnSingleKey(unitID);

                        if (mainBrandWbo != null) {
                            groupId = (String) mpr.getParameter("groupId");
                            groupName = (String) mpr.getParameter("groupName");
                        } else {
                            if (maintainableMgr.saveNewObject3(new WebBusinessObject(ht), now, flag)) {
                                parentUnitMgr.cashData();

                                request.setAttribute("Status", "Ok");
                            } else {
                                request.setAttribute("Status", "No");
                            }
                            ////////////////////////

                        }
                        parentWbo = (WebBusinessObject) maintainableMgr.getOnSingleKey(unitID);
                    } else {
                        maintainableMgr = MaintainableMgr.getInstance();
                        parentWbo = (WebBusinessObject) maintainableMgr.getOnSingleKey(mpr.getParameter("parentCategory"));
                        subGroupId = (String) mpr.getParameter("parentCategory");
                        maintainablerecord = maintainableMgr.getOnSingleKey((String) mpr.getParameter("parentCategory"));
                        groupId = (String) maintainablerecord.getAttribute("maintTypeId");

                    }
                    ///////////////////
                    flag = "equip";
                    maintainableMgr = MaintainableMgr.getInstance();
                    String fixedMachineNo = maintainableMgr.getFixedMachineNo(mpr.getParameter("equipmentName"));
                    String averageReading = maintainableMgr.getFixedMachineNo(mpr.getParameter("averageReading"));

                    String fileExtension = mpr.getParameter("fileExtension");
                    FileMgr fileMgr = FileMgr.getInstance();
                    WebBusinessObject fileDescriptor = fileMgr.getObjectFromCash(fileExtension);
                    String metaType = (String) fileDescriptor.getAttribute("metaType");


                    maintainableMgr = MaintainableMgr.getInstance();

                    dropdownDate = new DropdownDate();
                    c = Calendar.getInstance();


                    Integer unitLevel = new Integer(parentWbo.getAttribute("unitLevel").toString());

                    wbo = null;
                    ht = new Hashtable();
                    String ID = mpr.getParameter("equipmentID"); //UniqueIDGen.getNextID();
                    //maintenable unit data
                    ht.put("id", ID);
                    ht.put("parentId", subGroupId);
                    ht.put("unitLevel", unitLevel);

                    if (mpr.getParameter("equipmentNo").equals("0000")) {
                        ht.put("unitNo", fixedMachineNo);
                        erpFlag = "1";
                    } else {
                        ht.put("unitNo", mpr.getParameter("equipmentNo"));
                        erpFlag = "0";
                    }

                    if (mpr.getParameter("averageReading").equals("0")) {
                        ht.put("statusUnit", "0");
                    } else {
                        ht.put("statusUnit", "1");
                    }
                    String statusEq = mpr.getParameter("eqWork");
                    if (statusEq != null) {
                        if (statusEq.equalsIgnoreCase("1")) {
                            ht.put("statusUnit", "1");
                        } else {
                            ht.put("statusUnit", "2");
                        }
                    } else {
                        ht.put("statusUnit", "2");
                    }

                    String empId = (String) mpr.getParameter("AuthEmp");
                    WebBusinessObject wboEmp = new WebBusinessObject();
                    if (empId != null && !empId.equalsIgnoreCase("")) {
                        wboEmp = empBasicMgr.getOnSingleKey(empId);
                        empName = wboEmp.getAttribute("empName").toString();
                    } else {
                        empId = "";
                        empName = "";
                    }

                    ht.put("averageReading", mpr.getParameter("averageReading"));

                    if (mpr.getParameter("engineNo").equalsIgnoreCase("") || mpr.getParameter("engineNo") == null) {
                        ht.put("engineNo", "No Data");
                    } else {
                        ht.put("engineNo", mpr.getParameter("engineNo"));
                    }

                    if (mpr.getParameter("modelNo").equalsIgnoreCase("") || mpr.getParameter("modelNo") == null) {
                        ht.put("modelNo", "No Data");
                    } else {
                        ht.put("modelNo", mpr.getParameter("modelNo"));
                    }

                    if (mpr.getParameter("serialNo").equalsIgnoreCase("") || mpr.getParameter("serialNo") == null) {
                        ht.put("serialNo", "No Data");
                    } else {
                        ht.put("serialNo", mpr.getParameter("serialNo"));
                    }

                    ht.put("unitName", mpr.getParameter("equipmentName"));

                    if (mpr.getParameter("manufacturer") == null || mpr.getParameter("manufacturer").equalsIgnoreCase("")) {
                        ht.put("manufacturer", "No Data");
                    } else {
                        ht.put("manufacturer", mpr.getParameter("manufacturer"));
                    }

                    ht.put("location", mpr.getParameter("locations"));
                    ht.put("dept", mpr.getParameter("depts"));
                    ht.put("status", mpr.getParameter("status"));
                    ht.put("empID", empId);
                    ht.put("isMaintainable", new Integer(1));
                    ht.put("noOfHours", new Integer(0));
                    ht.put("productionLine", mpr.getParameter("productionLine"));
                    ht.put("erpFlag", erpFlag);
                    ht.put("user", userId);
                    ht.put("empName", empName);

//                    serviceDate = mpr.getParameter("serviceEntryDate").split("/");
//                    eYear=Integer.parseInt(serviceDate[2]);
//                    eMonth=Integer.parseInt(serviceDate[0]);
//                    eDay=Integer.parseInt(serviceDate[1]);
//                    serviceEntryDate=new java.sql.Date(eYear-1900,eMonth-1,eDay);

                    dateParser = new DateParser();
                    serviceEntryDate = dateParser.formatSqlDate(mpr.getParameter("serviceEntryDate"));

                    ht.put("serviceEntryDate", serviceEntryDate);

                    if (mpr.getParameter("checkIsStandalone") == null) {
                        ht.put("isStandalone", "0");
                    } else {
                        ht.put("isStandalone", "1");
                    }

                    //Handel empty desc
                    String desc = mpr.getParameter("equipmentDescription");
                    if (desc.equalsIgnoreCase("") || desc == null) {
                        ht.put("desc", "No Description");
                    } else {
                        ht.put("desc", mpr.getParameter("equipmentDescription"));
                    }

                    ht.put("rateType", mpr.getParameter("eqptype"));
                    if (mpr.getParameter("opration").toString().equalsIgnoreCase("Countinous")) {
                        ht.put("opType", "1");
                    } else {
                        ht.put("opType", "2");
                    }
                    ht.put("equipID", ID);

                    notes = mpr.getParameter("notes");
                    if (notes.equalsIgnoreCase("") || notes == null) {
                        ht.put("notes", "No Notes");
                    } else {
                        ht.put("notes", mpr.getParameter("notes"));
                    }
                    // maintainablerecord = maintainableMgr.getOnSingleKey((String)mpr.getParameter("parentCategory"));
                    ht.put("mainCat", groupId);

                    //Equipment Operation Data
                    ht.put("opeartionType", mpr.getParameter("opration"));
                    ht.put("average", new Integer(mpr.getParameter("average")));
                    WebBusinessObject savedObj = new WebBusinessObject();
                    try {
                        if (!maintainableMgr.getDoubleNameEquip(mpr.getParameter("equipmentName"))) {
                            if (maintainableMgr.saveSimpleEquipment(new WebBusinessObject(ht), now, flag)) {

                                WebBusinessObject tempWbo = maintainableMgr.getOnSingleKey(ID);
                                /** return eqpWbo with parentName and production line title and dept Name ... **/
                                savedObj = configureEqpWbo(tempWbo);

                                maintainableMgr.cashData();
                                request.setAttribute("Status", "Ok");

                                /******Create Dynamic contenet of Issue menu *******/
                                //open Jar File
                                metaMgr = MetaDataMgr.getInstance();
                                metaMgr.setMetaData("xfile.jar");
                                parseSideMenu = new ParseSideMenu();
                                eqpMenu = new Vector();
                                mode = (String) request.getSession().getAttribute("currentMode");
                                eqpMenu = parseSideMenu.parseSideMenu(mode, "equipment_menu.xml", "");

                                metaMgr.closeDataSource();

                                /* Add ids for links*/
                                linkVec = new Vector();
                                link = "";

                                style = new Hashtable();
                                style = (Hashtable) eqpMenu.get(0);
                                title = style.get("title").toString();
                                title += "<br>" + savedObj.getAttribute("unitName").toString();
                                style.remove("title");
                                style.put("title", title);

                                for (int i = 1; i < eqpMenu.size() - 1; i++) {
                                    linkVec = new Vector();
                                    link = "";
                                    linkVec = (Vector) eqpMenu.get(i);
                                    link = (String) linkVec.get(1);

                                    link += savedObj.getAttribute("id").toString();

                                    linkVec.remove(1);
                                    linkVec.add(link);
                                }

                                topMenu = new Hashtable();
                                tempVec = new Vector();
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

                                request.getSession().setAttribute("sideMenuVec", eqpMenu);
                                /*End of Menu*/

                                /****************************************************/
                            } else {
                                request.setAttribute("Status", "No");
                            }
                        } else {
                            request.setAttribute("Status", "No");
                            request.setAttribute("name", "Duplicate Name");
                        }
                        // }
                    } catch (NoUserInSessionException ex) {
                        logger.error(ex.getMessage());
                        request.setAttribute("Status", ex.getMessage());
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                        request.setAttribute("Status", ex.getMessage());
                    }

                    maintainableMgr = MaintainableMgr.getInstance();
                    categoryList = new ArrayList();
                    mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();
                    categoryList = new ArrayList();
                    ArrayList mainCategoryList = new ArrayList();

                    mainCategoryList = mainCategoryTypeMgr.getAllAsArrayList();

                    if (!mainCategoryList.isEmpty()) {
                        String mainCatTemp;
                        if (groupId == null) {
                            mainCatTemp = (String) ((WebBusinessObject) mainCategoryList.get(0)).getAttribute("id");
                        } else {
                            mainCatTemp = groupId;
                        }
                        categoryList = Tools.toArrayList(maintainableMgr.getParentIdAndName(mainCatTemp));
                    }

                    equipBase = mpr.getParameter("base");
                    String imageName = mpr.getParameter("imageName");
                    if (imageName != null) {
                        File newFile = new File(userBackendHome + ourPolicy.getFileName());

                        if (newFile.exists()) {

                            usrDir = new File(imageName);
                            usrDirContents = usrDir.list();

                            String docImageFilePath = userBackendHome + ourPolicy.getFileName();

                            FileIO.copyFile(docImageFilePath, userImageDir + "\\" + ourPolicy.getFileName());


                            String docType = mpr.getParameter("docType");
                            unitDocMgr.getInstance();
                            result = unitDocMgr.saveImageDocument(mpr, session, docImageFilePath);
                        }
                    }

                    eqpSequenceMgr = EqpSequenceMgr.getInstance();
                    eqpSequenceMgr.updateSequence();
                    String sequence = eqpSequenceMgr.getSequence();
                    request.setAttribute("eqpSequence", sequence);
                    backTo = (String) request.getParameter("backTo");
                    if (backTo != null) {
                        if (backTo.equalsIgnoreCase("prima")) {
                            servedPage = "EquipmentServlet?op=showTree&ID=" + mpr.getParameter("mainCategoryType");
                        } else {
                            servedPage = "/docs/newEquipment/new_simple_equipment.jsp";
                        }
                    } else {
                        servedPage = "/docs/newEquipment/new_simple_equipment.jsp";
                    }


                    maintainableMgr.executeProcedureMachine("txt");
                    fixedAssetsMachineMgr.cashData();

                    DepartmentMgr deptMgr = DepartmentMgr.getInstance();
                    productionLineMgr = ProductionLineMgr.getInstance();
                    ProjectMgr projectMgr = ProjectMgr.getInstance();

                    ArrayList deptsList = deptMgr.getCashedTableAsBusObjects();
                    ArrayList productLineList = productionLineMgr.getCashedTableAsBusObjects();
                    ArrayList locationsList = new ArrayList();
                    Vector tempProjects = new Vector();
                    tempProjects = userProjectsMgr.getOnArbitraryKey(securityUser.getUserId(), "key1");
                    locationsList = new ArrayList();
                    for (int i = 0; i < tempProjects.size(); i++) {
                        locationsList.add(tempProjects.get(i));
                    }

                    request.setAttribute("deptsList", deptsList);
                    request.setAttribute("productLineList", productLineList);
                    request.setAttribute("locationsList", locationsList);
                    request.setAttribute("defaultLocationName", securityUser.getSiteName());
                    request.setAttribute("defaultLocationId", securityUser.getSiteId());
                    request.setAttribute("savedObj", savedObj);
                    request.setAttribute("listWorkers", empBasicMgr.getCashedTableAsBusObjects());
                    request.setAttribute("base", equipBase);
                    request.setAttribute("mainCategoryList", mainCategoryList);
                    request.setAttribute("mainCategoryType", mpr.getParameter("mainCategoryType"));
                    request.setAttribute("categoryList", categoryList);
                    //request.setAttribute("page", servedPage);
                    this.forward(servedPage, request, response);
                    break;

                case 92:
                    empBasicMgr = EmpBasicMgr.getInstance();
                    equipBase = request.getParameter("base");
                    eqpSequenceMgr = EqpSequenceMgr.getInstance();
                    eqpSequenceMgr.updateSequence();
                    sequence = eqpSequenceMgr.getSequence();
                    maintainableMgr = MaintainableMgr.getInstance();
                    mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();
                    categoryList = new ArrayList();
                    mainCategoryList = new ArrayList();
                    categoryTemp = new Vector();

                    parentId = request.getParameter("parentId");
                    String parentName = request.getParameter("parentName");
                    String mainTypeName = null;
                    String mainTypeId = null;

                    maintainableMgr.executeProcedureMachine("txt");
                    fixedAssetsMachineMgr.cashData();

                    mainCategoryList = mainCategoryTypeMgr.getAllAsArrayList();

                    if (!mainCategoryList.isEmpty()) {
                        mainCat = (String) ((WebBusinessObject) mainCategoryList.get(0)).getAttribute("id");
                        categoryList = Tools.toArrayList(maintainableMgr.getParentIdAndName(mainCat));
                    }


                    if (parentId != null) {

                        mainTypeId = maintainableMgr.getMainTypeByModelId(parentId);
                        mainTypeName = mainCategoryTypeMgr.getMainTypeNameById(mainTypeId);

                        if (parentName == null || parentName.equalsIgnoreCase("")) {
                            parentName = maintainableMgr.getModelNameById(parentId);
                        }
                    }

                    deptMgr = DepartmentMgr.getInstance();
                    productionLineMgr = ProductionLineMgr.getInstance();
                    userProjectsMgr = UserProjectsMgr.getInstance();
                    tempProjects = new Vector();

                    tempProjects = userProjectsMgr.getOnArbitraryKey(securityUser.getUserId(), "key1");
                    locationsList = new ArrayList();
                    for (int i = 0; i < tempProjects.size(); i++) {
                        locationsList.add(tempProjects.get(i));
                    }

                    deptsList = deptMgr.getCashedTableAsBusObjects();
                    productLineList = productionLineMgr.getCashedTableAsBusObjects();

                    servedPage = "/docs/newEquipment/new_prima_equipment.jsp";
                    request.setAttribute("deptsList", deptsList);
                    request.setAttribute("productLineList", productLineList);
                    request.setAttribute("locationsList", locationsList);
                    request.setAttribute("defaultLocationName", securityUser.getSiteName());
                    request.setAttribute("defaultLocationId", securityUser.getSiteId());
                    request.setAttribute("base", equipBase);
                    request.setAttribute("eqpSequence", sequence);
                    request.setAttribute("mainCategoryList", mainCategoryList);
                    request.setAttribute("categoryList", categoryList);
                    request.setAttribute("mainTypeName", mainTypeName);
                    request.setAttribute("mainTypeId", mainTypeId);
                    request.setAttribute("parentName", parentName);
                    request.setAttribute("parentId", parentId);
                    this.forward(servedPage, request, response);
                    break;

                case 93:
                    eqID = (String) request.getParameter("equipmentID");
                    maintainableMgr = MaintainableMgr.getInstance();
                    eqWbo = maintainableMgr.getOnSingleKey(eqID);

                    mode = (String) request.getParameter("currentMode");
                    servedPage = "/docs/newEquipment/update_eqp_operation.jsp";
                    request.setAttribute("equipmentID", eqID);
                    request.setAttribute("currentMode", mode);
                    request.setAttribute("eqWbo", eqWbo);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 94:
                    String eqpId = request.getParameter("equipmentID");
                    maintainableMgr = MaintainableMgr.getInstance();
                    projectMgr = ProjectMgr.getInstance();
                    DepartmentMgr departmentMgr = DepartmentMgr.getInstance();
                    productionLineMgr = ProductionLineMgr.getInstance();
                    EquipOperationMgr eqpOpMgr = EquipOperationMgr.getInstance();
                    WebBusinessObject eqpOpWbo = new WebBusinessObject();
                    Vector eqpOpVector = new Vector();
                    AverageUnitMgr averageUnitMgr = AverageUnitMgr.getInstance();
                    WebBusinessObject parenetWbo = new WebBusinessObject();

                    WebBusinessObject eqpWbo = maintainableMgr.getOnSingleKey(eqpId);
                    WebBusinessObject locationWBO = projectMgr.getOnSingleKey(eqpWbo.getAttribute("site").toString());
                    WebBusinessObject deptWBO = departmentMgr.getOnSingleKey(eqpWbo.getAttribute("department").toString());
                    WebBusinessObject productionLineWBO = productionLineMgr.getOnSingleKey(eqpWbo.getAttribute("productionLine").toString());
                    try {
                        eqpOpVector = eqpOpMgr.getOnArbitraryKey(eqpWbo.getAttribute("id").toString(), "key1");
                        eqpOpWbo = (WebBusinessObject) eqpOpVector.elementAt(0);
                    } catch (Exception excep) {
                    }
                    try {
                        items = averageUnitMgr.getOnArbitraryKey(eqpId, "key1");
                        if (items.size() > 0) {
                            for (int i = 0; i < items.size(); i++) {
                                WebBusinessObject itemWbo = (WebBusinessObject) items.elementAt(i);
                                WebBusinessObject tempWbo = (WebBusinessObject) maintainableMgr.getOnSingleKey(itemWbo.getAttribute("unitName").toString());
                                categoryName = (String) tempWbo.getAttribute("unitName");
                                String unit = "";
                                if (eqpWbo.getAttribute("rateType").toString().equalsIgnoreCase("By K.M")) {
                                    unit = "km";
                                } else {
                                    unit = "hr";
                                }
                                itemWbo.getAttribute("acual_Reading").toString();
                                itemWbo.getAttribute("current_Reading").toString();

                                eqpWbo.setAttribute("acualReading", itemWbo.getAttribute("acual_Reading").toString());
                                eqpWbo.setAttribute("currentReading", itemWbo.getAttribute("current_Reading").toString());
                                eqpWbo.setAttribute("unit", unit);

                                Date d = Calendar.getInstance().getTime();
                                String readingDate = (String) itemWbo.getAttribute("entry_Time");
                                Long l = new Long(readingDate);
                                long sl = l.longValue();
                                d.setTime(sl);
                                readingDate = d.toString();
                                int year = d.getYear() + 1900;
                                int mon = d.getMonth() + 1;
                                int day = d.getDate();
                                readingDate = day + " / " + mon + " / " + year;
                                eqpWbo.setAttribute("readingDate", readingDate);
                            }
                        } else {
                            eqpWbo.setAttribute("acualReading", "No Reading");
                            eqpWbo.setAttribute("currentReading", "No Reading");
                            eqpWbo.setAttribute("unit", "");
                            eqpWbo.setAttribute("readingDate", "No Reading");
                        }
                    } catch (Exception excep) {
                    }

                    parenetWbo = maintainableMgr.getOnSingleKey(eqpWbo.getAttribute("parentId").toString());
                    eqpWbo.setAttribute("parentName", parenetWbo.getAttribute("unitName").toString());
                    eqpWbo.setAttribute("opType", eqpOpWbo.getAttribute("operation_type").toString());
                    eqpWbo.setAttribute("average", eqpOpWbo.getAttribute("average").toString());
                    eqpWbo.setAttribute("site", locationWBO.getAttribute("projectName").toString());
                    eqpWbo.setAttribute("productionLine", productionLineWBO.getAttribute("code").toString());
                    eqpWbo.setAttribute("department", deptWBO.getAttribute("departmentName").toString());

//                //open Jar File
//                MetaDataMgr metaMgr=MetaDataMgr.getInstance();
//                metaMgr.setMetaData("xfile.jar");
//                ParseSideMenu parseSideMenu=new ParseSideMenu();
//                Hashtable logos=new Hashtable();
//                logos=parseSideMenu.getCompanyLogo("configration.xml");
//                metaMgr.closeDataSource();


                    servedPage = "/docs/newEquipment/print_Equipment.jsp";
                    request.setAttribute("eqpWbo", eqpWbo);
//                    request.setAttribute("logos",session.getAttribute("logos"));
                    request.setAttribute("page", servedPage);
                    this.forward(servedPage, request, response);
                    break;

                case 95:

                    userObj = (WebBusinessObject) session.getAttribute("loggedUser");
                    String unitName = request.getParameter("unitName");
                    String unitCode = request.getParameter("unitCode");
                    String formName = request.getParameter("formName");

                    categoryTemp = new Vector();
                    count = 0;
                    url = "EquipmentServlet?op=listEquipmentsPopup";
                    maintainableMgr = MaintainableMgr.getInstance();

                    if (unitName != null && !unitName.equals("") && !unitName.equals("null")) {
                        String[] partsArr = unitName.split(",");
                        unitName = "";
                        for (int i = 0; i < partsArr.length; i++) {
                            char temp1 = (char) new Integer(partsArr[i]).intValue();
                            unitName += temp1;
                        }
                    }

                    try {
                        if (unitName != null && !unitName.equals("") && !unitName.equals("null")) {
                            categoryTemp = maintainableMgr.getEquipBySubNameOrCode(unitName, "name");

                        } else if (unitCode != null && !unitCode.equals("") && !unitCode.equals("null")) {
                            categoryTemp = maintainableMgr.getEquipBySubNameOrCode(unitCode, "code");

                        } else {

                            //        String params[]={"1","0",userObj.getAttribute("projectID").toString()};
//                                String keys[]={"key3","key5","key11"};
                            categoryTemp = maintainableMgr.getOnArbitraryDoubleKey("1", "key3", "0", "key5");
//                                categoryTemp = maintainableMgr.getOnArbitraryNumberKey(3,params,keys);

                        }
                    } catch (SQLException ex) {
                        Logger.getLogger(ComplexIssueServlet.class.getName()).log(Level.SEVERE, null, ex);
                    } catch (Exception ex) {
                        Logger.getLogger(ComplexIssueServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    tempcount = (String) request.getParameter("count");
                    if (tempcount != null) {
                        count = Integer.parseInt(tempcount);
                    }

                    category = new Vector();
                    wbo = new WebBusinessObject();
                    index = (count + 1) * 10;
                    id = "";
                    checkattched = new Vector();
                    supplementMgr = SupplementMgr.getInstance();
                    if (categoryTemp.size() < index) {
                        index = categoryTemp.size();
                    }
                    for (int i = count * 10; i < index; i++) {
                        wbo = (WebBusinessObject) categoryTemp.get(i);
                        category.add(wbo);
                    }

                    noOfLinks = categoryTemp.size() / 10f;
                    temp = "" + noOfLinks;
                    intNo = Integer.parseInt(temp.substring(temp.indexOf(".") + 1, temp.length()));
                    links = (int) noOfLinks;
                    if (intNo > 0) {
                        links++;
                    }
                    if (links == 1) {
                        links = 0;
                    }

                    servedPage = "/docs/newEquipment/list_equipments.jsp";

                    session.removeAttribute("CategoryID");

                    request.setAttribute("count", "" + count);
                    request.setAttribute("noOfLinks", "" + links);
                    request.setAttribute("fullUrl", url);
                    request.setAttribute("url", url);
                    request.setAttribute("unitName", unitName);
                    request.setAttribute("unitCode", unitCode);
                    request.setAttribute("formName", formName);
                    request.setAttribute("data", category);
                    request.setAttribute("page", servedPage);

                    this.forward(servedPage, request, response);
                    break;

                case 96:

                    eqID = (String) request.getParameter("equipmentID");
                    maintainableMgr = MaintainableMgr.getInstance();

                    WebBusinessObject operationWbo = new WebBusinessObject();
//                    operationWbo.setAttribute("averageReading",request.getParameter("averageReading"));
                    operationWbo.setAttribute("rateType", request.getParameter("eqptype"));

                    if (request.getParameter("opration").toString().equalsIgnoreCase("Countinous")) {
                        operationWbo.setAttribute("opType", "1");
                    } else {
                        operationWbo.setAttribute("opType", "2");
                    }
                    operationWbo.setAttribute("opeartionType", request.getParameter("opration"));
                    operationWbo.setAttribute("average", new Integer(request.getParameter("average")));
                    operationWbo.setAttribute("equipID", eqID);

                    now = timenow();
//                    if(maintainableMgr.updateEqpOperation(operationWbo,now))
                    if (maintainableMgr.updateEqOperation(operationWbo)) {
                        request.setAttribute("status", "ok");
                    } else {
                        request.setAttribute("status", "fail");
                    }

                    eqWbo = maintainableMgr.getOnSingleKey(eqID);

                    mode = (String) request.getParameter("currentMode");
                    servedPage = "/docs/newEquipment/update_eqp_operation.jsp";
                    request.setAttribute("equipmentID", eqID);
                    request.setAttribute("currentMode", mode);
                    request.setAttribute("eqWbo", eqWbo);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 97:
                    servedPage = "/docs/newEquipment/search_eqp_By_site.jsp";
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 98:

                    userObj = (WebBusinessObject) session.getAttribute("loggedUser");
                    String siteName = (String) request.getParameter("siteName");
                    formName = (String) request.getParameter("formName");

                    Vector sitesVec = new Vector();
                    Vector sites = new Vector();
                    projectMgr = ProjectMgr.getInstance();

                    categoryTemp = new Vector();
                    count = 0;
                    url = "EquipmentServlet?op=listSitesPopup";

                    if (siteName != null && !siteName.equals("")) {
                        String[] partsArr = siteName.split(",");
                        siteName = "";
                        for (int i = 0; i < partsArr.length; i++) {
                            char temp1 = (char) new Integer(partsArr[i]).intValue();
                            siteName += temp1;
                        }
                    }

                    try {
                        if (siteName != null && !siteName.equals("")) {
                            sitesVec = projectMgr.getSitesBySubName(siteName);

                        } else {
                            projectMgr.cashData();
                            sitesVec = projectMgr.getCashedTable();
                        }
                    } catch (Exception ex) {
                        Logger.getLogger(ComplexIssueServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }

                    tempcount = (String) request.getParameter("count");
                    if (tempcount != null) {
                        count = Integer.parseInt(tempcount);
                    }

                    wbo = new WebBusinessObject();
                    index = (count + 1) * 10;
                    id = "";
                    if (sitesVec.size() < index) {
                        index = sitesVec.size();
                    }

                    for (int i = count * 10; i < index; i++) {
                        wbo = (WebBusinessObject) sitesVec.get(i);
                        sites.add(wbo);
                    }

                    noOfLinks = sitesVec.size() / 10f;
                    temp = "" + noOfLinks;
                    intNo = Integer.parseInt(temp.substring(temp.indexOf(".") + 1, temp.length()));
                    links = (int) noOfLinks;
                    if (intNo > 0) {
                        links++;
                    }
                    if (links == 1) {
                        links = 0;
                    }

                    servedPage = "/docs/newEquipment/list_sites.jsp";

                    request.setAttribute("count", "" + count);
                    request.setAttribute("noOfLinks", "" + links);
                    request.setAttribute("fullUrl", url);
                    request.setAttribute("url", url);
                    request.setAttribute("siteName", siteName);
                    request.setAttribute("formName", formName);

                    request.setAttribute("data", sites);
                    request.setAttribute("page", servedPage);

                    this.forward(servedPage, request, response);
                    break;

                case 99:
                    String siteId = request.getParameter("siteId");
                    url = "EquipmentServlet?op=resultEqpBySite&siteId=" + siteId;
                    maintainableMgr = MaintainableMgr.getInstance();

                    keysValue = new String[3];
                    keysIndex = new String[3];

                    Vector eqpsBySite = new Vector();
                    userObj = (WebBusinessObject) session.getAttribute("loggedUser");
                    try {
                        if (siteId != null && !siteId.equals("")) {

                            keysValue[0] = "1";
                            keysValue[1] = "0";
                            keysValue[2] = siteId;
                            keysIndex[0] = "key3";
                            keysIndex[1] = "key5";
                            keysIndex[2] = "key11";

                            eqpsBySite = maintainableMgr.getOnArbitraryNumberKey(3, keysValue, keysIndex);
                        } else {
                            eqpsBySite = maintainableMgr.getOnArbitraryDoubleKey("0", "key5", "1", "key3");
                        }
                    } catch (SQLException ex) {
                        logger.error(ex.getMessage());
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }
                    category = new Vector();

                    count = 0;
                    tempcount = (String) request.getParameter("count");
                    if (tempcount != null) {
                        count = Integer.parseInt(tempcount);
                    }
//                    index=(count+1)*10;
                    index = (count + 1) * eqpsBySite.size();
                    if (eqpsBySite.size() < index) {
                        index = eqpsBySite.size();
                    }

                    checkattched = new Vector();
                    supplementMgr = SupplementMgr.getInstance();
                    id = "";
                    if (eqpsBySite.size() < index) {
                        index = eqpsBySite.size();
                    }
                    for (int i = count * 10; i < index; i++) {
                        wbo = (WebBusinessObject) eqpsBySite.get(i);
                        id = (String) wbo.getAttribute("id");
                        checkattched = supplementMgr.search(id);
                        if (checkattched.size() > 0) {
                            wbo.setAttribute("nowStatus", "attached");
                        } else {
                            checkattched = supplementMgr.searchAllowedEqps(id);
                            if (checkattched.size() > 0) {
                                wbo.setAttribute("nowStatus", "attached");
                            } else {
                                wbo.setAttribute("nowStatus", "notattached");
                            }
                        }
                        category.add(wbo);
                    }

                    noOfLinks = eqpsBySite.size() / 10f;
                    temp = "" + noOfLinks;
                    intNo = Integer.parseInt(temp.substring(temp.indexOf(".") + 1, temp.length()));
                    links = (int) noOfLinks;
                    if (intNo > 0) {
                        links++;
                    }
                    if (links == 1) {
                        links = 0;
                    }

                    lastFilter = url;
                    session.setAttribute("lastFilter", lastFilter);

                    topMenu = new Hashtable();
                    tempVec = new Vector();
                    topMenu = (Hashtable) request.getSession().getAttribute("topMenu");
                    if (topMenu != null && topMenu.size() > 0) {
                        tempVec = new Vector();
                        tempVec.add("lastFilter");
                        tempVec.add(lastFilter);
                        topMenu.put("lastFilter", tempVec);
                    } else {
                        topMenu = new Hashtable();
                        topMenu.put("jobOrder", new Vector());
                        topMenu.put("maintItem", new Vector());
                        topMenu.put("schedule", new Vector());
                        topMenu.put("equipment", new Vector());
                        tempVec = new Vector();
                        tempVec.add("lastFilter");
                        tempVec.add(lastFilter);
                        topMenu.put("lastFilter", tempVec);

                    }

                    request.getSession().setAttribute("topMenu", topMenu);

                    session.removeAttribute("CategoryID");
                    servedPage = "/docs/newEquipment/equipment_list.jsp";
                    request.setAttribute("siteId", siteId);
                    request.setAttribute("count", "" + count);
                    request.setAttribute("noOfLinks", "" + links);
                    request.setAttribute("fullUrl", url);
                    request.setAttribute("url", url);
                    request.setAttribute("data", category);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 100:

                    userObj = (WebBusinessObject) session.getAttribute("loggedUser");
                    mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();

                    unitName = (String) request.getParameter("unitName");
                    formName = (String) request.getParameter("formName");
                    categoryTemp = new Vector();
                    count = 0;
                    url = "EquipmentServlet?op=listMainCatPopup";

//                    if(unitName != null && !unitName.equals("")){
//                        String []partsArr = unitName.split(",");
//                        unitName = "";
//                        for (int i=0;i<partsArr.length;i++){
//                            char temp1 = (char) new Integer(partsArr[i]).intValue();
//                            unitName +=temp1;
//                        }
//                    }

                    try {
//                        if(unitName != null && !unitName.equals("")){
//                            categoryTemp = maintainableMgr.getEquipBySubNameOrCode(unitName,"name");
//                        }else {
                        categoryTemp = mainCategoryTypeMgr.getCashedTable();
//                        }
                    } catch (Exception ex) {
                        Logger.getLogger(ComplexIssueServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }

                    tempcount = (String) request.getParameter("count");
                    if (tempcount != null) {
                        count = Integer.parseInt(tempcount);
                    }

                    category = new Vector();
                    wbo = new WebBusinessObject();
                    index = (count + 1) * 10;
                    id = "";

                    if (categoryTemp.size() < index) {
                        index = categoryTemp.size();
                    }
                    for (int i = count * 10; i < index; i++) {
                        wbo = (WebBusinessObject) categoryTemp.get(i);
                        category.add(wbo);
                    }

                    noOfLinks = categoryTemp.size() / 10f;
                    temp = "" + noOfLinks;
                    intNo = Integer.parseInt(temp.substring(temp.indexOf(".") + 1, temp.length()));
                    links = (int) noOfLinks;
                    if (intNo > 0) {
                        links++;
                    }
                    if (links == 1) {
                        links = 0;
                    }

                    servedPage = "/docs/newEquipment/list_mainCats.jsp";

                    request.setAttribute("count", "" + count);
                    request.setAttribute("noOfLinks", "" + links);
                    request.setAttribute("fullUrl", url);
                    request.setAttribute("url", url);
                    request.setAttribute("unitName", unitName);
                    request.setAttribute("formName", formName);

                    request.setAttribute("data", category);
                    request.setAttribute("page", servedPage);

                    this.forward(servedPage, request, response);
                    break;

                case 101:

                    maintainableMgr = MaintainableMgr.getInstance();
                    try {
                        maintainableMgr.deletObject(request.getParameter("equipmentID"));
                    } catch (Exception ex) {
                        logger.error("Delete Equipment Supplier Exception --> " + ex.getMessage());
                    }

                    maintainableMgr.cashData();
                    request.getSession().removeAttribute("sideMenuVec");
                    servedPage = "/manager_agenda.jsp";
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);

                    break;

                case 102:

                    request.getSession().removeAttribute("topMenu");
                    servedPage = "/manager_agenda.jsp";
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 103:
                    eqID = (String) request.getParameter("equipmentID");
                    maintainableMgr = MaintainableMgr.getInstance();
                    eqWbo = maintainableMgr.getOnSingleKey(eqID);

                    mode = (String) request.getParameter("currentMode");
                    servedPage = "/docs/newEquipment/add_eqp_manuf_data.jsp";
                    request.setAttribute("equipmentID", eqID);
                    request.setAttribute("currentMode", mode);
                    request.setAttribute("eqWbo", eqWbo);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 104:

                    eqID = (String) request.getParameter("equipmentID");
                    maintainableMgr = MaintainableMgr.getInstance();

                    WebBusinessObject manufactWbo = new WebBusinessObject();
                    String modelNo = request.getParameter("modelNo");
                    String serialNo = request.getParameter("serialNo");
                    String engineNo = request.getParameter("engineNo");
                    String manufacturer = request.getParameter("manufacturer");

                    manufactWbo.setAttribute("manufacturer", manufacturer);
                    manufactWbo.setAttribute("serialNo", serialNo);
                    manufactWbo.setAttribute("modelNo", modelNo);
                    manufactWbo.setAttribute("engineNo", engineNo);
                    manufactWbo.setAttribute("id", eqID);

//                    operationWbo=new WebBusinessObject();
//                    operationWbo.setAttribute("rateType",request.getParameter("eqptype"));

//                    if (request.getParameter("opration").toString().equalsIgnoreCase("Countinous")) {
//                        operationWbo.setAttribute("opType", "1");
//                    } else {
//                        operationWbo.setAttribute("opType", "2");
//                    }
//                    operationWbo.setAttribute("opeartionType",request.getParameter("opration"));
//                    operationWbo.setAttribute("average",new Integer(request.getParameter("average")));
//                    operationWbo.setAttribute("equipID",eqID);
//
//                    now = timenow();
//                    if(maintainableMgr.updateEqOperation(operationWbo)){
                    if (maintainableMgr.updateEqManuf(manufactWbo)) {
                        request.setAttribute("status", "ok");
                    } else {
                        request.setAttribute("status", "fail");
                    }
//                    }else{
//                        request.setAttribute("status","fail");
//                    }

                    eqWbo = maintainableMgr.getOnSingleKey(eqID);

                    mode = (String) request.getParameter("currentMode");
                    servedPage = "/docs/newEquipment/add_eqp_manuf_data.jsp";
                    request.setAttribute("equipmentID", eqID);
                    request.setAttribute("currentMode", mode);
                    request.setAttribute("eqWbo", eqWbo);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;


                case 105:

                    eqID = (String) request.getParameter("equipmentID");

                    maintainableMgr = MaintainableMgr.getInstance();
                    eqWbo = maintainableMgr.getOnSingleKey(eqID);

                    mode = (String) request.getParameter("currentMode");
                    servedPage = "/docs/newEquipment/update_warranty_data.jsp";
                    request.setAttribute("equipmentID", eqID);
                    request.setAttribute("currentMode", mode);
                    request.setAttribute("equipmentName", (String) eqWbo.getAttribute("unitName"));


                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 106:

                    eqID = (String) request.getParameter("equipmentID");
                    maintainableMgr = MaintainableMgr.getInstance();
                    eqWbo = maintainableMgr.getOnSingleKey(eqID);
                    String beg_Date = (String) request.getParameter("beginDate");
                    String end_Date = (String) request.getParameter("endDate");
                    request.setAttribute("warrantyType", (String) eqWbo.getAttribute("id").toString());
                    request.setAttribute("beginDate", beg_Date);
                    request.setAttribute("endDate", end_Date);

                    mode = (String) request.getParameter("currentMode");
                    servedPage = "/docs/newEquipment/update_warranty_data.jsp";
                    maintainableMgr = MaintainableMgr.getInstance();
                    if (maintainableMgr.updateWarrantyData(request, eqID)) {
                        status = "ok";
                    } else {
                        status = "false";
                    }

                    request.setAttribute("status", status);
                    request.setAttribute("equipmentID", eqID);
                    request.setAttribute("currentMode", mode);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;


                case 107:
                    maintainableMgr = MaintainableMgr.getInstance();


                    backToUrl = (String) session.getAttribute("lastFilter");
                    if (backToUrl != null && !backToUrl.equalsIgnoreCase("")) {
                        this.forward(backToUrl, request, response);
                    }

                    maintainableMgr.cashData();
                    categoryTemp = maintainableMgr.getOnArbitraryDoubleKey("1", "key3", "0", "key5");
                    category = new Vector();
//                    for (int i = 0; i < categoryTemp.size(); i++) {
//                        wbo = (WebBusinessObject) categoryTemp.get(i);
//                        //                     if (wbo.getAttribute("isMaintainable").toString().equalsIgnoreCase("1") && wbo.getAttribute("isDeleted").toString().equalsIgnoreCase("0")) {
//                        category.add(wbo);
//                        //                     }
//                    }
                    count = 0;
                    tempcount = (String) request.getParameter("count");
                    if (tempcount != null) {
                        count = Integer.parseInt(tempcount);
                    }
//                    index=(count+1)*10;
                    index = (count + 1) * categoryTemp.size();
                    checkattched = new Vector();
                    supplementMgr = SupplementMgr.getInstance();
                    id = "";
                    if (categoryTemp.size() < index) {
                        index = categoryTemp.size();
                    }
                    for (int i = count * 10; i < index; i++) {
                        wbo = (WebBusinessObject) categoryTemp.get(i);
                        id = (String) wbo.getAttribute("id");
                        checkattched = supplementMgr.search(id);
                        if (checkattched.size() > 0) {
                            wbo.setAttribute("nowStatus", "attached");
                        } else {
                            checkattched = supplementMgr.searchAllowedEqps(id);
                            if (checkattched.size() > 0) {
                                wbo.setAttribute("nowStatus", "attached");
                            } else {
                                wbo.setAttribute("nowStatus", "notattached");
                            }
                        }
                        category.add(wbo);
                    }

                    noOfLinks = categoryTemp.size() / 10f;
                    temp = "" + noOfLinks;
                    intNo = Integer.parseInt(temp.substring(temp.indexOf(".") + 1, temp.length()));
                    links = (int) noOfLinks;
                    if (intNo > 0) {
                        links++;
                    }
                    if (links == 1) {
                        links = 0;
                    }

                    servedPage = "/docs/newEquipment/equipment_list.jsp";
//                  request.getSession().setAttribute("isDelete","deleted");
                    request.setAttribute("count", "" + count);
                    request.setAttribute("noOfLinks", "" + links);
                    tempurl = (String) request.getParameter("url");
                    request.setAttribute("url", tempurl);
                    request.setAttribute("fullUrl", tempurl);
                    request.setAttribute("data", category);

                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);

                    break;

                case 108:
                    servedPage = "/docs/newEquipment/future_maintenance_pupop.jsp";
                    equipmentMaintenanceMgr = EquipmentMaintenanceMgr.getInstance();
                    vecIssues = equipmentMaintenanceMgr.getFutureMaintenace(request.getParameter("equipmentID"));

                    request.setAttribute("vecIssuesFuture", vecIssues);
                    request.setAttribute("unitName", request.getParameter("unitName"));
                    this.forward(servedPage, request, response);
                    break;

                case 109:
                    equipmentID = request.getParameter("equipmentID");

                    if (maintainableMgr.deleteEquipment(equipmentID)) {
                        servedPage = "EquipmentServlet?op=backToList";
                    } else {
                        servedPage = "EquipmentServlet?op=ConfirmEquipmentDelete&equipmentID=" + equipmentID;
                        request.setAttribute("status", "no");
                    }

                    this.forward(servedPage, request, response);
                    break;

                case 110:
                    categoryID = request.getParameter("categoryID");
                    categoryName = request.getParameter("categoryName");

                    categoryName = Tools.getRealChar(categoryName);

                    servedPage = "/docs/newEquipment/confirm_delete_maint_cat.jsp";
                    request.setAttribute("categoryID", categoryID);
                    request.setAttribute("categoryName", categoryName);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 111:
                    categoryID = request.getParameter("categoryID");
                    categoryName = request.getParameter("categoryName");

                    mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();
                    if (mainCategoryTypeMgr.deleteMainCategoryWithAccessories(categoryID)) {
                        servedPage = "EquipmentServlet?op=ListMainCategory";
                    } else {
                        servedPage = "EquipmentServlet?op=confirmDeleteMainCategory&categoryID=" + categoryID + "&categoryName=" + categoryName;
                        request.setAttribute("status", "no");
                    }

                    this.forward(servedPage, request, response);
                    break;

                case 112:
                    servedPage = "docs/newEquipment/form_details.jsp";
                    SelfDocMgr selfDocMgr = SelfDocMgr.getInstance();
                    Vector<WebBusinessObject> formsWbo = new Vector<WebBusinessObject>();
                    String formCode = request.getParameter("formCode");
                    formsWbo = selfDocMgr.getFormsList(formCode);
                    request.setAttribute("formsWbo", formsWbo);
                    this.forward(servedPage, request, response);
                    break;


                case 113:
                    servedPage = "docs/newEquipment/mainType_Tree1.jsp";
                    ArrayList mainCatTypes = new ArrayList();

                    mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();
                    mainCatTypes = mainCategoryTypeMgr.getCashedTableAsArrayList();

                    request.setAttribute("data", mainCatTypes);
                    request.setAttribute("page", servedPage);
                    this.forwardToServedPage(request, response);
                    break;

                case 114:
                    servedPage = "docs/equipment/mainType_Tree1.jsp";
                    Vector Brands = new Vector();
                    Vector Eqp = new Vector();
                    mainCatTypes = new ArrayList();
                    mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();
                    String Id = request.getParameter("ID");

                    mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();
                    mainCatTypes = mainCategoryTypeMgr.getCashedTableAsArrayList();


                    String Name = mainCategoryTypeMgr.getMainType(Id);
                    Brands = maintainableMgr.getBrandByBasictype(Id);
                    request.setAttribute("data", mainCatTypes);
                    request.setAttribute("mainName", Name);
                    request.setAttribute("brands", Brands);
                    request.setAttribute("page", servedPage);

                    this.forwardToServedPage(request, response);
                    break;
                case 115:
                    servedPage = "docs/newEquipment/mainType_Tree1.jsp";
                    Brands = new Vector();
                    Eqp = new Vector();
                    mainCatTypes = new ArrayList();
                    mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();
                    Id = request.getParameter("ID");
                    mainCategoryTypeMgr = MainCategoryTypeMgr.getInstance();
                    mainCatTypes = mainCategoryTypeMgr.getCashedTableAsArrayList();
                    Name = mainCategoryTypeMgr.getMainType(Id);
                    Brands = maintainableMgr.getBrandByBasictype(Id);
                    request.setAttribute("data", mainCatTypes);
                    request.setAttribute("mainName", Name);
                    request.setAttribute("brands", Brands);
                    request.setAttribute("page", servedPage);

                    this.forwardToServedPage(request, response);
                    break;

                case 116:
                    servedPage = "/docs/new_search/equipmentListByModel.jsp";
                    com.silkworm.pagination.Filter filter = new com.silkworm.pagination.Filter();
                    Vector schedules = new Vector();
                    //String[] sitesAll = request.getParameterValues("site");
                    //String sites_all = request.getParameter("site");//Tools.concatenation(sitesAll, ",");
                    parentId = request.getParameter("parentId");
                    String eqpName = request.getParameter("eqpName");

                    filter = Tools.getPaginationInfo(request, response);
                    List<FilterCondition> conditions = new ArrayList<FilterCondition>();
                    if (parentId != null) {
                        conditions.add(new FilterCondition("PARENT_ID", parentId, Operations.EQUAL));
                    }
                    if (eqpName != null) {
                        conditions.add(new FilterCondition("UNIT_NAME", eqpName, Operations.LIKE));
                    }
                    if (conditions != null) {
                        filter.setConditions(conditions);
                    }
                    maintainableMgr = MaintainableMgr.getInstance();
                    List<WebBusinessObject> equipmentLists = new ArrayList<WebBusinessObject>(0);

                    //grab scheduleList list
                    try {
                        equipmentLists = maintainableMgr.paginationEntity(filter);
                    } catch (Exception e) {
                        System.out.println(e);
                    }
                    String selectionType = request.getParameter("selectionType");

                    if (selectionType == null) {
                        selectionType = "single";
                    }


                    formName = (String) request.getParameter("formName");

                    if (formName == null) {
                        formName = "";
                    }

                    request.setAttribute("selectionType", selectionType);
                    request.setAttribute("filter", filter);
                    request.setAttribute("formName", formName);
                    request.setAttribute("parentId", parentId);
                    request.setAttribute("scheduleList", equipmentLists);
                    this.forward(servedPage, request, response);
                    break;
                default:
                    logger.info("No operation was matched");
            }
        } catch (SQLException ex) {
            logger.error(ex.getMessage());
        } catch (Exception ex) {
            logger.error(ex.getMessage());
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    public String getServletInfo() {
        return "Equipment Servlet";
    }

    protected int getOpCode(String opName) {
        if (opName.equals("GetCategoryForm")) {
            return 1;
        }

        if (opName.equals("SaveCategory")) {
            return 2;
        }

//        if (opName.equals("GetEquipmentForm")) {
//            return 3;
//        }

//        if (opName.equals("SaveEquipment")) {
//            return 4;
//        }

        if (opName.equals("ListCategory")) {
            return 5;
        }

        if (opName.equals("ViewCategory")) {
            return 6;
        }

        if (opName.equals("GetUpdateForm")) {
            return 7;
        }

        if (opName.equals("UpdateCategory")) {
            return 8;
        }

        if (opName.equals("confirmDelete")) {
            return 9;
        }

        if (opName.equals("DeleteCategory")) {
            return 10;
        }

        if (opName.equals("ListEquipment")) {
            return 11;
        }

        if (opName.equals("ViewEquipment")) {
            return 12;
        }

        if (opName.equals("GetUpdateEquipmentForm")) {
            return 13;
        }

        if (opName.equals("UpdateEquipment")) {
            return 14;
        }

        if (opName.equals("ConfirmEquipmentDelete")) {
            return 15;
        }

        if (opName.equals("DeleteEquipment")) {
            return 16;
        }

        if (opName.equals("ListSiteEquipment")) {
            return 17;
        }

        if (opName.equals("EquipmentCategoryTree")) {
            return 18;
        }

        if (opName.equals("EquipmentTree")) {
            return 19;
        }

        if (opName.equals("EquipmentsByCategories")) {
            return 20;
        }
        if (opName.equals("ViewUnits")) {
            return 21;
        }

        if (opName.equals("SearchEquipmentForm")) {
            return 22;
        }

        if (opName.equals("SearchEquipmentResult")) {
            return 23;
        }

        if (opName.equals("ViewTabEquipment")) {
            return 24;
        }

        if (opName.equals("FutureMaintenance")) {
            return 25;
        }

        if (opName.equals("ClosedMaintenance")) {
            return 26;
        }

        if (opName.equals("NumberList")) {
            return 27;
        }

        if (opName.equals("CategoryList")) {
            return 28;
        }

        if (opName.equals("GetChangeForm")) {
            return 29;
        }

        if (opName.equals("SaveChange")) {
            return 30;
        }

        if (opName.equals("ListChanges")) {
            return 31;
        }

        if (opName.equals("ListJobOrders")) {
            return 32;
        }

        if (opName.equals("ViewJobEquipment")) {
            return 33;
        }

        if (opName.equals("ListInWarranty")) {
            return 34;
        }

        if (opName.equals("ListOutWarranty")) {
            return 35;
        }

        if (opName.equals("SearchEquipByDep")) {
            return 36;
        }
        if (opName.equals("SearchEquipmentDep")) {
            return 37;
        }

        if (opName.equals("GetSupplierForm")) {
            return 38;
        }

        if (opName.equals("SaveSupplier")) {
            return 39;
        }

        if (opName.equals("ListEquipmentSuppliers")) {
            return 40;
        }

        if (opName.equals("DeleteEquipmentSupplier")) {
            return 41;
        }

        if (opName.equals("SearchEquipByPro")) {
            return 42;
        }

        if (opName.equals("ResultSearchEquipByPro")) {
            return 43;
        }

        if (opName.equals("ListAttachedEquipment")) {
            return 44;
        }
        if (opName.equals("addDelayReason")) {
            return 45;
        }
        if (opName.equals("saveDelayReasons")) {
            return 46;
        }
        if (opName.equals("viewDelayReasons")) {
            return 47;
        }
        if (opName.equals("updateManuf")) {
            return 48;
        }
        if (opName.equals("saveUpdateManuf")) {
            return 49;
        }
        if (opName.equals("GetUpdateEqOpForm")) {
            return 50;
        }
        if (opName.equals("saveUpdateOperation")) {
            return 51;
        }
        if (opName.equals("GetUpdateEqWarrantyForm")) {
            return 52;
        }
        if (opName.equals("saveUpdateEqWarranty")) {
            return 53;
        }
        if (opName.equals("GetUpdateEqBasicDataForm")) {
            return 54;
        }
        if (opName.equals("saveUpdateEqBasicData")) {
            return 55;
        }
        if (opName.equals("viewAttachedeqps")) {
            return 56;
        }
        if (opName.equals("addWarrantyData")) {
            return 57;
        }
        if (opName.equals("saveWarrantyData")) {
            return 58;
        }
        if (opName.equals("viewWarrantyData")) {
            return 59;
        }
        if (opName.equals("getMainTypeForm")) {
            return 60;
        }
        if (opName.equals("SaveMainCategory")) {
            return 61;
        }
        if (opName.equals("ListMainCategory")) {
            return 62;
        }
        if (opName.equals("ViewMainCategory")) {
            return 63;
        }
        if (opName.equals("GetUpdateMainForm")) {
            return 64;
        }
        if (opName.equals("UpdateMainCategory")) {
            return 65;
        }
        if (opName.equals("deleteMainCategory")) {
            return 66;
        }
        if (opName.equals("selectEqReport")) {
            return 67;
        }
        if (opName.equals("getEqReport")) {
            return 68;
        }
        if (opName.equals("selectEqReportMainType")) {
            return 69;
        }
        if (opName.equals("getEqReportMainType")) {
            return 70;
        }
        if (opName.equals("mainCategoriesReport")) {
            return 71;
        }
        if (opName.equals("getEqStatusReportForm")) {
            return 72;
        }
        if (opName.equals("eqStatusReport")) {
            return 73;
        }
        if (opName.equals("getEqTableReportForm")) {
            return 74;
        }
        if (opName.equals("eqTablesReport")) {
            return 75;
        }
        if (opName.equals("getEqJOReportForm")) {
            return 76;
        }
        if (opName.equals("eqJOReport")) {
            return 77;
        }
        if (opName.equals("eqReadingReport")) {
            return 78;
        }
        if (opName.equals("MaintenanceItemsReport")) {
            return 79;
        }
        if (opName.equals("OutWorkingEqpsReportForm")) {
            return 80;
        }
        if (opName.equals("OutWorkingEqpsReport")) {
            return 81;
        }
        if (opName.equals("allOutWorkingEqpsReportForm")) {
            return 82;
        }
        if (opName.equals("GetProductionLineReportForm")) {
            return 83;
        }
        if (opName.equals("ProductionLineEqpsReport")) {
            return 84;
        }
        if (opName.equals("OutWorkingEqpsWithOutJOReport")) {
            return 85;
        }
        if (opName.equals("extractToExcel")) {
            return 86;
        }
        if (opName.equals("extractToExcelCategories")) {
            return 87;
        }
        if (opName.equals("EquipmentsByMainCat")) {
            return 88;
        }
        if (opName.equals("viewMainCatEqps")) {
            return 89;
        }
//        if (opName.equals("GetSimpleEqpForm")) {
//            return 90;
//        }
        if (opName.equals("saveSimpleEqp")) {
            return 91;
        }
        if (opName.equals("GetPrimaEqpForm")) {
            return 92;
        }
        if (opName.equals("getEqpOperationForm")) {
            return 93;
        }
        if (opName.equals("getPrintEqpForm")) {
            return 94;
        }
        if (opName.equals("listEquipmentsPopup")) {
            return 95;
        }
        if (opName.equals("updateEqpOperation")) {
            return 96;
        }
        if (opName.equals("SearchEqpBySite")) {
            return 97;
        }
        if (opName.equals("listSitesPopup")) {
            return 98;
        }
        if (opName.equals("resultEqpBySite")) {
            return 99;
        }
        if (opName.equals("listMainCatPopup")) {
            return 100;
        }
        if (opName.equals("deleteEquipment")) {
            return 101;
        }
        if (opName.equals("cancelFilter")) {
            return 102;
        }
        if (opName.equals("getmanufForm")) {
            return 103;
        }
        if (opName.equals("savemanufactorerData")) {
            return 104;
        }


        if (opName.equals("changeWarrantyData")) {
            return 105;
        }

        if (opName.equals("updateWarrantyData")) {
            return 106;
        }
        if (opName.equals("backToList")) {
            return 107;
        }
        if (opName.equals("getFutureMaintenace")) {
            return 108;
        }
        if (opName.equals("deleteExactlyEquipment")) {
            return 109;
        }
        if (opName.equals("confirmDeleteMainCategory")) {
            return 110;
        }
        if (opName.equals("deleteExactlyMainCategory")) {
            return 111;
        }
        if (opName.equals("getFormDetails")) {
            return 112;
        }
        if (opName.equals("ListMainTypes")) {
            return 113;
        }
        if (opName.equals("showTree")) {
            return 114;
        }
        if (opName.equals("showTree1")) {
            return 115;
        }
        if (opName.equals("ListEquipments")) {
            return 116;
        }


        return 0;

    }

    public long timenow() {

        Date d = Calendar.getInstance().getTime();

        long nowTime = d.getTime();
        return nowTime;
    }

    public Vector checkIsAgroupEq(Vector eqps, Vector mainParents) {
        WebBusinessObject eqWbo = null;
        WebBusinessObject parentWbo = null;
        String parentId = "";
        for (int i = 0; i < eqps.size(); i++) {
            eqWbo = new WebBusinessObject();
            parentId = "";
            eqWbo = (WebBusinessObject) eqps.get(i);
            parentId = eqWbo.getAttribute("maintTypeId").toString();
            for (int c = 0; c < mainParents.size(); c++) {
                parentWbo = new WebBusinessObject();
                parentWbo = (WebBusinessObject) mainParents.get(c);
                if (parentWbo.getAttribute("id").toString().equalsIgnoreCase(parentId)) {
                    if (parentWbo.getAttribute("isAgroupEq").toString().equals("1")) {
                        eqps.remove(i);
                        i--;
                    }
                    break;
                }
            }
        }
        return eqps;
    }

    private WebBusinessObject configureEqpWbo(WebBusinessObject eqpWbo) {
        ProjectMgr projectMgr = ProjectMgr.getInstance();
        DepartmentMgr departmentMgr = DepartmentMgr.getInstance();
        ProductionLineMgr productionLineMgr = ProductionLineMgr.getInstance();

        WebBusinessObject tempWbo = projectMgr.getOnSingleKey(eqpWbo.getAttribute("site").toString());
        eqpWbo.setAttribute("siteName", tempWbo.getAttribute("projectName").toString());
        tempWbo = new WebBusinessObject();

        tempWbo = departmentMgr.getOnSingleKey(eqpWbo.getAttribute("department").toString());
        eqpWbo.setAttribute("departmentName", tempWbo.getAttribute("departmentName"));

        tempWbo = new WebBusinessObject();
        tempWbo = productionLineMgr.getOnSingleKey(eqpWbo.getAttribute("productionLine").toString());
        eqpWbo.setAttribute("lineName", tempWbo.getAttribute("code"));

        tempWbo = new WebBusinessObject();
        tempWbo = maintainableMgr.getOnSingleKey(eqpWbo.getAttribute("parentId").toString());
        eqpWbo.setAttribute("parentName", tempWbo.getAttribute("unitName"));

        return eqpWbo;
    }
}
