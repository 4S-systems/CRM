package com.DatabaseController.servlets;

import com.DatabaseController.db_access.DatabaseConfigurationMgr;
import com.DatabaseController.db_access.DatabaseControllerMgr;
import com.clients.db_access.AppointmentMgr;
import com.clients.db_access.ClientComplaintsMgr;
import com.clients.db_access.ClientMgr;
import com.crm.common.CRMConstants;
import com.crm.db_access.CommentsMgr;
import com.crm.servlets.CommentsServlet;
import com.maintenance.common.Tools;
import com.maintenance.common.UserDepartmentConfigMgr;
import com.maintenance.db_access.DistributionListMgr;
import com.maintenance.db_access.IssueByComplaintMgr;
import com.maintenance.db_access.UnitScheduleMgr;
import com.silkworm.Exceptions.NoUserInSessionException;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.common.ExtDbConnectionMgr;
import com.silkworm.common.MetaDataMgr;
import com.silkworm.common.SecurityUser;
import com.silkworm.common.UserMgr;
import com.silkworm.db_access.PersistentSessionMgr;
import com.silkworm.logger.db_access.BusinessObjectTypeMgr;
import com.silkworm.logger.db_access.EventTypeMgr;
import com.silkworm.logger.db_access.LoggerMgr;

import com.silkworm.persistence.relational.NoSuchColumnException;
import com.silkworm.persistence.relational.UnsupportedConversionException;
import com.silkworm.persistence.relational.UnsupportedTypeException;
import com.tracker.db_access.IssueMgr;
import com.tracker.db_access.ProjectMgr;
import com.tracker.servlets.IssueServlet.IssueTitle;
import com.tracker.servlets.TrackerBaseServlet;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Enumeration;
import java.util.Iterator;
import java.util.List;
import java.util.StringTokenizer;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletConfig;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.commons.lang.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.input.SAXBuilder;

public class DatabaseControllerServlet extends TrackerBaseServlet {

    DatabaseControllerMgr databaseControllerMgr = DatabaseControllerMgr.getInstance();
    DatabaseConfigurationMgr databaseConfigurationMgr = DatabaseConfigurationMgr.getInstance();
    MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
    LoggerMgr loggerMgr = LoggerMgr.getInstance();
    IssueMgr issueMgr = IssueMgr.getInstance();
    UnitScheduleMgr unitScheduleMgr = UnitScheduleMgr.getInstance();

    Vector<WebBusinessObject> summary, allViews, validViews, invalidViews;
    WebBusinessObject wbo;
    SAXBuilder builder = new SAXBuilder();
    Document doc = null;
    Element elements = null;
    StringTokenizer tokenizer;
    String query;
    String isMultiStatement;
    String viewQuary;
    String viewName;
    String viewIndex;
    String path = metaDataMgr.getWebInfPath();
    String databaseUpdateXmlPath = path + "/database/DataBaseUpdate.xml";
    String viewsXmlPath = path + "/database/Views.xml";
    String bank, units, pay;
    boolean noErrors = true;
    Long currentIndex = new Long(0);
    int index;

    @Override
    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        super.processRequest(request, response);
        HttpSession session = request.getSession();
        WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        String remoteAccess = session.getId();
        WebBusinessObject persistentUser = (WebBusinessObject) PersistentSessionMgr.getInstance().getOnSingleKey(remoteAccess);
        operation = getOpCode((String) request.getParameter("op"));
        String issueId;
        switch (operation) {
            case 1:
                summary = new Vector();
                noErrors = true;
                currentIndex = new Long(0);
                String blockIndex = "";
                String queryBlock = "";
                
                try {
                    doc = builder.build(new File(databaseUpdateXmlPath));
                } catch (JDOMException e) {
                    logger.error(e.getMessage());
                }
                
                elements = doc.getRootElement();
                List lst = elements.getChildren();
                Integer oldIndex = new Integer(0);
                try {
                    oldIndex = databaseControllerMgr.getLastIndex();
                } catch (UnsupportedTypeException ex) {
                    logger.error(ex.getMessage());
                } catch (NoSuchColumnException ex) {
                    logger.error(ex.getMessage());
                } catch (UnsupportedConversionException ex) {
                    logger.error(ex.getMessage());
                } catch (SQLException ex) {
                    logger.error(ex.getMessage());
                }
                
                Iterator itr = lst.iterator();
                while (itr.hasNext()) { // for all blocks
                    
                    Element block = (Element) itr.next();
                    blockIndex = block.getChild("sqlindex").getText();
                    
                    currentIndex = new Long(blockIndex);
                    
                    if (currentIndex > oldIndex) { // new Blocks only
                        queryBlock = block.getChild("statment").getText();
                        isMultiStatement = block.getChild("isMultiStatement").getText();
                        
                        logger.debug(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Query IS " + queryBlock);
                        logger.debug(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>blockIndex " + blockIndex);
                        logger.debug(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>before executing");
                        
                        if (isMultiStatement != null && isMultiStatement.equals("1")) {
                            tokenizer = new StringTokenizer(queryBlock, ";");
                            while (tokenizer.hasMoreTokens()) { //for all statements in the Block
                                query = tokenizer.nextToken();
                                try {
                                    manageStatement(query, blockIndex);
                                } catch (Exception ex) {
                                    logger.error(ex.getMessage());
                                    break;
                                }
                            }
                        } else {
                            try {
                                manageStatement(queryBlock, blockIndex);
                            } catch (Exception ex) {
                                logger.error(ex.getMessage());
                                break;
                            }
                        }
                    }
                    
                    if (!noErrors) {
                        break;
                    }
                }
                
                try {
                    databaseControllerMgr.updateLastIndes(currentIndex);
                } catch (SQLException e) {
                    logger.error(e.getMessage());
                }
                
                servedPage = "/docs/database_controller/update_database_report.jsp";
                request.setAttribute("page", servedPage);
                request.setAttribute("summary", summary);
                request.setAttribute("noErrors", noErrors);
                this.forwardToServedPage(request, response);
                break;
                
            case 2:
                ExtDbConnectionMgr extDbConnectionMgr = ExtDbConnectionMgr.getInstance();
                extDbConnectionMgr.cashData();
                if (extDbConnectionMgr.getCashedTable().size() > 0) {
                    try {
                        WebBusinessObject unitsDBWbo = (WebBusinessObject) extDbConnectionMgr.getOnArbitraryKey("units", "key1").get(0);
                        WebBusinessObject bankDBWbo = (WebBusinessObject) extDbConnectionMgr.getOnArbitraryKey("bank", "key1").get(0);
                        boolean strIsFound = databaseControllerMgr.isSchemaFound(unitsDBWbo.getAttribute("userName").toString());
                        boolean isStrConnected = databaseControllerMgr.isConnected(unitsDBWbo.getAttribute("hostName").toString(), unitsDBWbo.getAttribute("serviceName").toString(), unitsDBWbo.getAttribute("userName").toString(), unitsDBWbo.getAttribute("password").toString());
                        if (strIsFound && isStrConnected) {
                            unitsDBWbo.setAttribute("valid", "1");
                        } else {
                            unitsDBWbo.setAttribute("valid", "0");
                        }
                        boolean glIsFound = databaseControllerMgr.isSchemaFound(bankDBWbo.getAttribute("userName").toString());
                        boolean isGlConnected = databaseControllerMgr.isConnected(bankDBWbo.getAttribute("hostName").toString(), bankDBWbo.getAttribute("serviceName").toString(), bankDBWbo.getAttribute("userName").toString(), bankDBWbo.getAttribute("password").toString());
                        if (glIsFound && isGlConnected) {
                            bankDBWbo.setAttribute("valid", "1");
                        } else {
                            bankDBWbo.setAttribute("valid", "0");
                        }
                        request.setAttribute("unitsDBWbo", unitsDBWbo);
                        request.setAttribute("bankDBWbo", bankDBWbo);
                    } catch (SQLException ex) {
                        Logger.getLogger(DatabaseControllerServlet.class.getName()).log(Level.SEVERE, null, ex);
                    } catch (Exception ex) {
                        Logger.getLogger(DatabaseControllerServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
                servedPage = "/docs/database_controller/enter_schema_names_form.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 3:
                bank = request.getParameter("bank").toUpperCase();
                units = request.getParameter("units").toUpperCase();
                summary = new Vector();
                
                try {
                    doc = builder.build(new File(viewsXmlPath));
                } catch (JDOMException ex) {
                    logger.error(ex.getMessage());
                }
                
                elements = doc.getRootElement();
                List<Element> listElements = elements.getChildren();
                
                for (Element element : listElements) {
                    viewIndex = element.getChild("viewindex").getText();
                    viewName = element.getChild("viewname").getText();
                    viewQuary = element.getChild("viewstatment").getText().trim();
                    
                    // replace all schema names for erp
                    viewQuary = viewQuary.replaceAll(DatabaseControllerMgr._BANK, bank);
                    viewQuary = viewQuary.replaceAll(DatabaseControllerMgr._UNITS, units);
                    
                    wbo = new WebBusinessObject();
                    wbo.setAttribute("viewIndex", viewIndex);
                    wbo.setAttribute("viewQuary", viewName);
                    
                    try {
                        databaseControllerMgr.execute(viewQuary);
                        wbo.setAttribute("message", "Success");
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                        wbo.setAttribute("message", ex.getMessage());
                    }
                    summary.addElement(wbo);
                }
                
                // resetting for database configuration
                databaseConfigurationMgr.setErpGeneralLedgerUser(bank);
                databaseConfigurationMgr.setErpGeneralLedgerPassword(bank);
                databaseConfigurationMgr.setErpStoreUser(units);
                databaseConfigurationMgr.setErpStorePassword(units);
                databaseConfigurationMgr.updateDatabaseConfigurationXML();
                servedPage = "/docs/database_controller/all_views.jsp";
                request.setAttribute("page", servedPage);
                request.setAttribute("summary", summary);
                this.forwardToServedPage(request, response);
                break;
                
            case 4:
                wbo = databaseControllerMgr.checkAllViews();
                allViews = new Vector<WebBusinessObject>();
                validViews = (Vector<WebBusinessObject>) wbo.getAttribute(DatabaseControllerMgr.VIEW_VALID_STATUS);
                invalidViews = (Vector<WebBusinessObject>) wbo.getAttribute(DatabaseControllerMgr.VIEW_INVALID_STATUS);
                index = 1;
                for (WebBusinessObject wbo : invalidViews) {
                    wbo.setAttribute("message", "InValid");
                    wbo.setAttribute("viewIndex", String.valueOf(index));
                    allViews.addElement(wbo);
                    index++;
                }
                for (WebBusinessObject wbo : validViews) {
                    wbo.setAttribute("message", "Valid");
                    wbo.setAttribute("viewIndex", String.valueOf(index));
                    allViews.addElement(wbo);
                    index++;
                }
                servedPage = "/docs/database_controller/all_views.jsp";
                request.setAttribute("page", servedPage);
                request.setAttribute("summary", allViews);
                this.forwardToServedPage(request, response);
                break;
                
            case 5:
                servedPage = "/docs/database_controller/database_configuration_view.jsp";
                
                request.setAttribute("basicUrlInfo", databaseConfigurationMgr.getBasicUrlInfo());
                request.setAttribute("erpUrlInfo", databaseConfigurationMgr.getErpUrlInfo());
                
                request.setAttribute("basicUser", databaseConfigurationMgr.getBasicUser());
                
                request.setAttribute("erpGerneralLedgerUser", databaseConfigurationMgr.getErpGeneralLedgerUser());
                request.setAttribute("statusErpGerneralLedgerUser", databaseControllerMgr.isSchemaFound(databaseConfigurationMgr.getErpGeneralLedgerUser()));
                request.setAttribute("erpStoreUser", databaseConfigurationMgr.getErpStoreUser());
                request.setAttribute("statusErpStoreUser", databaseControllerMgr.isSchemaFound(databaseConfigurationMgr.getErpStoreUser()));
                request.setAttribute("erpPayrollUser", databaseConfigurationMgr.getErpPayrollUser());
                request.setAttribute("statusErpPayrollUser", databaseControllerMgr.isSchemaFound(databaseConfigurationMgr.getErpPayrollUser()));
                
                request.setAttribute("statusAsset", databaseControllerMgr.isSchemaFound(metaDataMgr.getAssetErpName()));
                request.setAttribute("statusStores", databaseControllerMgr.isSchemaFound(metaDataMgr.getStoreErpName()));
                
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 6:
                servedPage = "/docs/database_controller/viewDatabaseLog.jsp";
                Vector objectTypes = new Vector();
                Vector loggerMsgs = new Vector();
                String busObjectType = request.getParameter("busObjectType");
                String eventType = request.getParameter("eventType");
                String fromDateStr = request.getParameter("fromDate");
                String toDateStr = request.getParameter("toDate");
                String content = request.getParameter("content");
                Calendar c = Calendar.getInstance();
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                if (fromDateStr == null || fromDateStr.isEmpty()) {
                    toDateStr = sdf.format(c.getTime());
                    c.add(Calendar.DATE, -1);
                    fromDateStr = sdf.format(c.getTime());
                }
                try {
                    c.setTime(sdf.parse(fromDateStr));
                    c.set(Calendar.HOUR_OF_DAY, 0);
                    c.set(Calendar.MINUTE, 0);
                    c.set(Calendar.SECOND, 0);
                    Date fromDate = c.getTime();
                    c.setTime(sdf.parse(toDateStr));
                    c.set(Calendar.HOUR_OF_DAY, 23);
                    c.set(Calendar.MINUTE, 59);
                    c.set(Calendar.SECOND, 59);
                    Date toDate = c.getTime();
                    loggerMsgs = loggerMgr.getAllLogs(busObjectType, eventType, new Timestamp(fromDate.getTime()), new Timestamp(toDate.getTime()), content);
                } catch (ParseException ex) {
                    Logger.getLogger(DatabaseControllerServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                
                ArrayList objectTypesArray = new ArrayList();
//                objectTypes = objectTypeMgr.getAllData();
                Enumeration e = objectTypes.elements();
                while (e.hasMoreElements()) {
                    objectTypesArray.add(e.nextElement());
                }
                BusinessObjectTypeMgr.getInstance().cashData();
                EventTypeMgr.getInstance().cashData();
                request.setAttribute("busObjectTypeList", BusinessObjectTypeMgr.getInstance().getCashedTableAsArrayList());
                request.setAttribute("eventTypeList", EventTypeMgr.getInstance().getCashedTableAsArrayList());
                request.setAttribute("selectedObjectType", busObjectType);
                request.setAttribute("selectedEventType", eventType);
                request.setAttribute("fromDate", fromDateStr);
                request.setAttribute("toDate", toDateStr);
                request.setAttribute("logger", loggerMsgs);
                request.setAttribute("objectTypes", objectTypesArray);
                request.setAttribute("content", content);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 7:
                servedPage = "/docs/database_controller/confirm_delete_all_issues.jsp";
                request.setAttribute("numberOfEmergencyIssue", unitScheduleMgr.getNumberIssues(IssueTitle.Emergency));
                request.setAttribute("numberOfNotEmergencyIssue", unitScheduleMgr.getNumberIssues(IssueTitle.NotEmergency));
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 8:
                if (issueMgr.deleteAllIssues()) {
                    request.setAttribute("status", "ok");
                    
                    // remove topMenu and sideMenuVec
                    session.removeAttribute("sideMenuVec");
                    session.removeAttribute("topMenu");
                } else {
                    request.setAttribute("status", "no");
                }
                servedPage = "DatabaseControllerServlet?op=confirmDeleteAllIssues";
                this.forward(servedPage, request, response);
                break;
                
            case 9:
                extDbConnectionMgr = ExtDbConnectionMgr.getInstance();
                extDbConnectionMgr = ExtDbConnectionMgr.getInstance();
                extDbConnectionMgr.cashData();
                if (extDbConnectionMgr.getCashedTable() != null && extDbConnectionMgr.getCashedTable().size() > 0) {
                    try {
                        WebBusinessObject unitDBWbo = (WebBusinessObject) extDbConnectionMgr.getOnArbitraryKey("units", "key1").get(0);
                        WebBusinessObject bankDBWbo = (WebBusinessObject) extDbConnectionMgr.getOnArbitraryKey("bank", "key1").get(0);
                        boolean strIsFound = databaseControllerMgr.isSchemaFound(unitDBWbo.getAttribute("userName").toString());
                        boolean isStrConnected = databaseControllerMgr.isConnected(unitDBWbo.getAttribute("hostName").toString(), unitDBWbo.getAttribute("serviceName").toString(), unitDBWbo.getAttribute("userName").toString(), unitDBWbo.getAttribute("password").toString());
                        if (strIsFound && isStrConnected) {
                            unitDBWbo.setAttribute("valid", "1");
                        } else {
                            unitDBWbo.setAttribute("valid", "0");
                        }
                        boolean glIsFound = databaseControllerMgr.isSchemaFound(bankDBWbo.getAttribute("userName").toString());
                        boolean isGlConnected = databaseControllerMgr.isConnected(bankDBWbo.getAttribute("hostName").toString(), bankDBWbo.getAttribute("serviceName").toString(), bankDBWbo.getAttribute("userName").toString(), bankDBWbo.getAttribute("password").toString());
                        if (glIsFound && isGlConnected) {
                            bankDBWbo.setAttribute("valid", "1");
                        } else {
                            bankDBWbo.setAttribute("valid", "0");
                        }
                        request.setAttribute("unitDBWbo", unitDBWbo);
                        request.setAttribute("bankDBWbo", bankDBWbo);
                    } catch (SQLException ex) {
                        Logger.getLogger(DatabaseControllerServlet.class.getName()).log(Level.SEVERE, null, ex);
                    } catch (Exception ex) {
                        Logger.getLogger(DatabaseControllerServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
                metaDataMgr = MetaDataMgr.getInstance();
                String[] arrUrl = metaDataMgr.getDataBaseURL().split("@");
                request.setAttribute("arrDatabase", arrUrl[1]);
                servedPage = "/docs/Adminstration/set_ext_connection.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 10:
                extDbConnectionMgr = ExtDbConnectionMgr.getInstance();
                String[] hostName = request.getParameterValues("hostName");
                String[] serviceName = request.getParameterValues("serviceName");
                String[] userName = request.getParameterValues("userName");
                String[] password = request.getParameterValues("password");
                String[] dbType = request.getParameterValues("dbType");
                try {
                    extDbConnectionMgr.deleteOnArbitraryKey("units", "key1");
                    extDbConnectionMgr.deleteOnArbitraryKey("bank", "key1");
                } catch (SQLException ex) {
                    Logger.getLogger(DatabaseControllerServlet.class.getName()).log(Level.SEVERE, null, ex);
                } catch (Exception ex) {
                    Logger.getLogger(DatabaseControllerServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                for (int x = 0; x < hostName.length; x++) {
                    try {
                        WebBusinessObject saveWbo = new WebBusinessObject();
                        saveWbo.setAttribute("host", hostName[x]);
                        saveWbo.setAttribute("service", serviceName[x]);
                        saveWbo.setAttribute("user", userName[x]);
                        saveWbo.setAttribute("password", password[x]);
                        saveWbo.setAttribute("dbType", dbType[x]);
                        extDbConnectionMgr.saveObject(saveWbo);
                    } catch (SQLException ex) {
                        Logger.getLogger(DatabaseControllerServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
                
                MetaDataMgr metaMgr = MetaDataMgr.getInstance();
                String databaseErpUrl = "jdbc:oracle:thin:@";
                extDbConnectionMgr.cashData();
                if (extDbConnectionMgr.getCashedTable() != null && extDbConnectionMgr.getCashedTable().size() > 0) {
                    try {
                        WebBusinessObject unitDBWbo = (WebBusinessObject) extDbConnectionMgr.getOnArbitraryKey("units", "key1").get(0);
                        WebBusinessObject bankDBWbo = (WebBusinessObject) extDbConnectionMgr.getOnArbitraryKey("bank", "key1").get(0);
                        boolean strIsFound = databaseControllerMgr.isSchemaFound(unitDBWbo.getAttribute("userName").toString());
                        boolean isStrConnected = databaseControllerMgr.isConnected(unitDBWbo.getAttribute("hostName").toString(), unitDBWbo.getAttribute("serviceName").toString(), unitDBWbo.getAttribute("userName").toString(), unitDBWbo.getAttribute("password").toString());
                        if (strIsFound && isStrConnected) {
                            unitDBWbo.setAttribute("valid", "1");
                        } else {
                            unitDBWbo.setAttribute("valid", "0");
                        }
                        boolean glIsFound = databaseControllerMgr.isSchemaFound(bankDBWbo.getAttribute("userName").toString());
                        boolean isGlConnected = databaseControllerMgr.isConnected(bankDBWbo.getAttribute("hostName").toString(), bankDBWbo.getAttribute("serviceName").toString(), bankDBWbo.getAttribute("userName").toString(), bankDBWbo.getAttribute("password").toString());
                        if (glIsFound && isGlConnected) {
                            bankDBWbo.setAttribute("valid", "1");
                        } else {
                            bankDBWbo.setAttribute("valid", "0");
                        }
                        request.setAttribute("unitDBWbo", unitDBWbo);
                        request.setAttribute("bankDBWbo", bankDBWbo);
                        metaMgr.setDataBaseErpUrl(databaseErpUrl + unitDBWbo.getAttribute("hostName").toString() + ":1521:" + unitDBWbo.getAttribute("serviceName").toString());
                        metaMgr.setStoreErpName(unitDBWbo.getAttribute("userName").toString());
                        metaMgr.setStoreErpPassword(unitDBWbo.getAttribute("password").toString());
                        metaMgr.setAssetErpName(bankDBWbo.getAttribute("userName").toString());
                        metaMgr.setAssetErpPassword(bankDBWbo.getAttribute("password").toString());
                    } catch (SQLException ex) {
                        Logger.getLogger(DatabaseControllerServlet.class.getName()).log(Level.SEVERE, null, ex);
                    } catch (Exception ex) {
                        Logger.getLogger(DatabaseControllerServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
                metaDataMgr = MetaDataMgr.getInstance();
                arrUrl = metaDataMgr.getDataBaseURL().split("@");
                request.setAttribute("arrDatabase", arrUrl[1]);
                servedPage = "/docs/Adminstration/set_ext_connection.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 11:
                servedPage = "/docs/Adminstration/Delete_Users.jsp";
                DistributionListMgr distributionListMgr = DistributionListMgr.getInstance();
                
                Vector arrayOfUsers=null;
                try {
                    arrayOfUsers = userMgr.getAllEmps();
                } catch (SQLException ex) {
                    Logger.getLogger(DatabaseControllerServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                for(int i=0; i<arrayOfUsers.size(); i++){
                    wbo = (WebBusinessObject)arrayOfUsers.get(i);
                    if(wbo.getAttribute("userId") != null){
                        try {
                            if (issueMgr.getOnArbitraryKey((String)wbo.getAttribute("userId"), "key1").size() > 0
                                    || distributionListMgr.getOnArbitraryKeyOracle((String)wbo.getAttribute("userId"), "key2").size() > 0
                                    || distributionListMgr.getOnArbitraryKeyOracle((String)wbo.getAttribute("userId"), "key3").size() > 0) {
                                wbo.setAttribute("status", "1");
                            } else {
                                wbo.setAttribute("status", "0");
                            }
                        } catch (Exception ex) {
                            Logger.getLogger(DatabaseControllerServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }
                    
                }
                request.setAttribute("users", arrayOfUsers);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 12:
                servedPage = "/docs/Adminstration/Disjoin_Managers.jsp";
                ArrayList<WebBusinessObject> arrayOfManagers = userMgr.getManagers();
                request.setAttribute("managers", arrayOfManagers);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 13:
                servedPage = "/docs/Adminstration/clear_error_tasks.jsp";
                String beginDate = request.getParameter("beginDate");
                String endDate = request.getParameter("endDate");
                String issueType = request.getParameter("issueType");
                if (beginDate != null && endDate != null) {
                    request.setAttribute("data", issueMgr.getClearErrorTasks(beginDate, endDate, issueType));
                }
                request.setAttribute("beginDate", beginDate);
                request.setAttribute("endDate", endDate);
                request.setAttribute("issueType", issueType);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 14:
                servedPage = "/docs/Adminstration/clear_error_tasks.jsp";
                beginDate = request.getParameter("beginDate");
                endDate = request.getParameter("endDate");
                issueType = request.getParameter("issueType");
                issueId = request.getParameter("issueId");
                if (issueId != null && !issueId.isEmpty()) {
                    try {
                        if (issueMgr.deleteAllIssueData(issueId)) {
                            request.setAttribute("status", "ok");
                        } else {
                            request.setAttribute("status", "fail");
                        }
                    } catch (SQLException ex) {
                        Logger.getLogger(DatabaseControllerServlet.class.getName()).log(Level.SEVERE, null, ex);
                        request.setAttribute("status", "fail");
                    }
                }
                if (beginDate != null && endDate != null) {
                    request.setAttribute("data", issueMgr.getClearErrorTasks(beginDate, endDate, issueType));
                }
                request.setAttribute("beginDate", beginDate);
                request.setAttribute("endDate", endDate);
                request.setAttribute("issueType", issueType);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 15:
                servedPage = "/docs/client/drag_client.jsp";
                String searchByValue = request.getParameter("searchByValue");
                if (searchByValue != null) {
                    request.setAttribute("data", issueMgr.getClearErrorTasksByBusiness(searchByValue));
                }
                SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");
                String empUser = UserMgr.getInstance().getByKeyColumnValue("key", (String) persistentUser.getAttribute("userId"),"key2");
                if( empUser.equals("0") ){
                try {
                    request.setAttribute("employees", userMgr.getUsersByGroupAndBranch(securityUser.getDistributionGroup(), securityUser.getBranchesAsArray()));
                } catch (SQLException ex) {
                    request.setAttribute("employees", new ArrayList<>());
                }
                } else {
                try {
                    request.setAttribute("employees", userMgr.getUsersByDistributionGroup( (String) persistentUser.getAttribute("userId")));
                } catch (SQLException ex) {
                    request.setAttribute("employees", new ArrayList<>());
                }

                }
                try {
                    request.setAttribute("requestTypes", new ArrayList<>(ProjectMgr.getInstance().getOnArbitraryKey("RQ-TYPE", "key4")));
                } catch (Exception ex) {
                    request.setAttribute("requestTypes", new ArrayList<>());
                }
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 16:
                
                // this code commented out by walid
                // what was it doing in here??
                String flag = "";
                flag = request.getParameter("flag");
                
                String requestType = new String();
                String employeeID = new String();
                String[] selectedIssue = null;
                
                if("report".equals(flag)){
                    servedPage = "/docs/client/client_campaigns_report.jsp";
                } else {
                    servedPage = "/DatabaseControllerServlet?op=dragClientForm";
                }
                
                issueId = request.getParameter("issueId");
                String clientID;
                if (issueId != null && !issueId.isEmpty()) {
                    try {
                        //For logging Withdraw Client
                        WebBusinessObject issueWbo = issueMgr.getOnSingleKey(issueId);
                        WebBusinessObject clientWbo;
                        ClientMgr clientMgr = ClientMgr.getInstance();
                        if (issueWbo != null) {
                            clientID = (String) issueWbo.getAttribute("clientId");
                            if (clientID == null || clientID.isEmpty()) {
                                clientID = (String) request.getParameter("clientId");
                            }
                            clientWbo = clientMgr.getOnSingleKey(clientID);
                        } else {
                            clientWbo = null;
                            clientID = null;
                        }
                        WebBusinessObject loggerWbo = new WebBusinessObject();
                        WebBusinessObject clientComplaintWbo = ClientComplaintsMgr.getInstance().getClientComplaintByIssueAndType(issueId, CRMConstants.CLIENT_COMPLAINT_TYPE_ORDER);
                        loggerWbo.setAttribute("objectXml", clientComplaintWbo != null ? clientComplaintWbo.getObjectAsXML() : issueWbo.getObjectAsXML());
                        loggerWbo.setAttribute("realObjectId", clientID == null ? "---" : clientID);
                        loggerWbo.setAttribute("userId", persistentUser.getAttribute("userId"));
                        loggerWbo.setAttribute("objectName", clientWbo != null ? clientWbo.getAttribute("clientNO") : "---");
                        loggerWbo.setAttribute("loggerMessage", "Withdraw Client");
                        loggerWbo.setAttribute("eventName", "Withdraw");
                        loggerWbo.setAttribute("objectTypeId", "1");
                        loggerWbo.setAttribute("eventTypeId", "5");
                        loggerWbo.setAttribute("ipForClient", getClientIpAddr(request));
                        String callStatus = (String) issueWbo.getAttribute("issueType");
                        String callType = (String) issueWbo.getAttribute("callType");
                        securityUser = (SecurityUser) session.getAttribute("securityUser");
                        ClientComplaintsMgr clientComplaintsMgr = ClientComplaintsMgr.getInstance();
                        String comment = request.getParameter("requestType");
                        ArrayList<WebBusinessObject> distributionList = new ArrayList<>(DistributionListMgr.getInstance().getDistributionListByIssueID(issueId));
                        if (issueMgr.addWithdrawInfo((String) persistentUser.getAttribute("userId"), distributionList, clientWbo, loggerWbo)
                                && issueMgr.deleteAllIssueData(issueId) && AppointmentMgr.getInstance().deleteAllFutureAppointments(clientID)) {
                            request.setAttribute("status", "ok");
                            if (request.getParameter("employeeID") != null) {
                                try {
                                    if (securityUser != null && securityUser.getCallcenterMode() != null && !securityUser.getCallcenterMode().equals("1")) {
                                        issueId = issueMgr.saveCallDataAuto(clientID, callType, callStatus, session, "issue", persistentUser);
                                    }
                                } catch (NoUserInSessionException | SQLException ex) {
                                    logger.error(ex);
                                }
                                try {
                                    if (issueId != null) {
                                        clientComplaintsMgr.createMailInBox((String) persistentUser.getAttribute("userId"),
                                                request.getParameter("employeeID"), issueId, "2", null,
                                                comment, comment, comment);
                                    }
                                } catch (SQLException ex) {
                                    logger.error(ex);
                                }
                            }
                        } else {
                            request.setAttribute("status", "fail");
                        }
                    } catch (SQLException ex) {
                        logger.error(ex);
                        request.setAttribute("status", "fail");
                    }
                } else {
                    requestType = request.getParameter("requestType");
                    employeeID = request.getParameter("employeeID");
                    selectedIssue = request.getParameterValues("selectedIssue");
                    if(selectedIssue != null && selectedIssue.length > 0){
                        for (int i=0; i<selectedIssue.length; i++){
                            try {
                                //For logging Withdraw Client
                                WebBusinessObject issueWbo = issueMgr.getOnSingleKey(selectedIssue[i]);
                                WebBusinessObject loggerWbo = new WebBusinessObject();
                                WebBusinessObject clientComplaintWbo = ClientComplaintsMgr.getInstance().getClientComplaintByIssueAndType(issueId, CRMConstants.CLIENT_COMPLAINT_TYPE_ORDER);
                                loggerWbo.setAttribute("objectXml", clientComplaintWbo != null ? clientComplaintWbo.getObjectAsXML() : issueWbo.getObjectAsXML());
                                loggerWbo.setAttribute("realObjectId", selectedIssue[i]);
                                loggerWbo.setAttribute("userId", persistentUser.getAttribute("userId"));
                                loggerWbo.setAttribute("objectName", issueWbo.getAttribute("businessID"));
                                loggerWbo.setAttribute("loggerMessage", "Withdraw Client");
                                loggerWbo.setAttribute("eventName", "Withdraw");
                                loggerWbo.setAttribute("objectTypeId", "1");
                                loggerWbo.setAttribute("eventTypeId", "5");
                                loggerWbo.setAttribute("ipForClient", getClientIpAddr(request));
                                clientID = (String) issueWbo.getAttribute("clientId");
                                String callStatus = (String) issueWbo.getAttribute("issueType");
                                String callType = (String) issueWbo.getAttribute("callType");
                                securityUser = (SecurityUser) session.getAttribute("securityUser");
                                ClientComplaintsMgr clientComplaintsMgr = ClientComplaintsMgr.getInstance();
                                String comment = request.getParameter("requestType");
                                ArrayList<WebBusinessObject> distributionList = new ArrayList<>(DistributionListMgr.getInstance().getDistributionListByIssueID(selectedIssue[i]));
                                WebBusinessObject clientWbo = ClientMgr.getInstance().getOnSingleKey(clientID);
                                if (issueMgr.addWithdrawInfo((String) persistentUser.getAttribute("userId"), distributionList, clientWbo, loggerWbo)
                                        && issueMgr.deleteAllIssueData(selectedIssue[i]) && AppointmentMgr.getInstance().deleteAllFutureAppointments(clientID)) {
                                    request.setAttribute("statusWithdraw", "ok");
                                    if (request.getParameter("employeeID") != null) {
                                        try {
                                            if (securityUser != null && securityUser.getCallcenterMode() != null && !securityUser.getCallcenterMode().equals("1")) {
                                                selectedIssue[i] = issueMgr.saveCallDataAuto(clientID, callType, callStatus, session, "issue", persistentUser);
                                            }
                                        } catch (NoUserInSessionException | SQLException ex) {
                                            logger.error(ex);
                                        }
                                        try {
                                            if (selectedIssue[i] != null) {
                                                clientComplaintsMgr.createMailInBox((String) persistentUser.getAttribute("userId"),
                                                        request.getParameter("employeeID"), selectedIssue[i], "2", null,
                                                        comment, comment, comment);
                                            }
                                        } catch (SQLException ex) {
                                            logger.error(ex);
                                        }
                                    }
                                } else {
                                    request.setAttribute("statusWithdraw", "fail");
                                }
                            } catch (SQLException ex) {
                                logger.error(ex);
                                request.setAttribute("statusWithdraw", "fail"); 
                            }
                        }
                    }
                    servedPage = "/DatabaseControllerServlet?op=withdrawDistributions";
                }
                
                this.forward(servedPage, request, response);
                break;
            case 17:
                servedPage = "/docs/issue/withdraw_distributions.jsp";
                if (request.getParameterValues("selectedIssue") != null && request.getParameter("searchType") != null
                        && request.getParameter("searchType").equals("delete")) {
                    String[] issues = request.getParameterValues("selectedIssue");
                    WebBusinessObject loggerWbo = new WebBusinessObject();
                    WebBusinessObject complaintWbo;
                    ClientComplaintsMgr clientComplaintsMgr = ClientComplaintsMgr.getInstance();
                    String clientComplaintID;
                    for (String issueID : issues) {
                        try {
                            clientComplaintID = request.getParameter("clientComplaintID" + issueID);
                            complaintWbo = clientComplaintsMgr.getOnSingleKey(clientComplaintID);
                            loggerWbo.setAttribute("objectXml", complaintWbo.getObjectAsXML());
                            loggerWbo.setAttribute("realObjectId", issueID);
                            loggerWbo.setAttribute("userId", persistentUser.getAttribute("userId"));
                            loggerWbo.setAttribute("objectName", complaintWbo.getAttribute("businessID"));
                            loggerWbo.setAttribute("loggerMessage", "Withdraw Client");
                            loggerWbo.setAttribute("eventName", "Withdraw");
                            loggerWbo.setAttribute("objectTypeId", "1");
                            loggerWbo.setAttribute("eventTypeId", "5");
                            loggerWbo.setAttribute("ipForClient", getClientIpAddr(request));
                            
                            clientID = (String) request.getParameter("clientID" + issueID);
                            ArrayList<WebBusinessObject> distributionList = new ArrayList<>(DistributionListMgr.getInstance().getDistributionListByIssueID(issueID));
                            WebBusinessObject clientWbo = ClientMgr.getInstance().getOnSingleKey(clientID);
                            if (issueMgr.addWithdrawInfo((String) persistentUser.getAttribute("userId"), distributionList, clientWbo, loggerWbo)
                                    && issueMgr.deleteAllIssueData(issueID) && AppointmentMgr.getInstance().deleteAllFutureAppointments(clientID)) {
                                request.setAttribute("status", "ok");
                            } else {
                                request.setAttribute("status", "fail");
                            }
                        } catch (SQLException ex) {
                            Logger.getLogger(DatabaseControllerServlet.class.getName()).log(Level.SEVERE, null, ex);
                        } catch (Exception ex) {
                            Logger.getLogger(DatabaseControllerServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }
                }
                
                ArrayList<WebBusinessObject> departments = new ArrayList<>();
                UserDepartmentConfigMgr userDepartmentConfigMgr = UserDepartmentConfigMgr.getInstance();
                ProjectMgr projectMgr = ProjectMgr.getInstance();
                String selectedDepartment = request.getParameter("departmentID");
                String allDepartmentIDs = "";
                try {
                    ArrayList<WebBusinessObject> userDepartments = new ArrayList<>(userDepartmentConfigMgr.getOnArbitraryKeyOracle((String) loggedUser.getAttribute("userId"), "key2"));
                    String[] ids = new String[userDepartments.size()];
                    int index = 0;
                    for (WebBusinessObject userDepartmentWbo : userDepartments) {
                        departments.add(projectMgr.getOnSingleKey((String) userDepartmentWbo.getAttribute("department_id")));
                        ids[index++] = (String) userDepartmentWbo.getAttribute("department_id");
                    }
                    allDepartmentIDs = Tools.arrayToString(ids, "','");
                    if (departments.isEmpty()) {
                        WebBusinessObject wboTemp = new WebBusinessObject();
                        wboTemp.setAttribute("projectName", "لا يوجد");
                        wboTemp.setAttribute("projectID", "none");
                        departments.add(wboTemp);
                    } else {
                        if (selectedDepartment == null) {
                            selectedDepartment = "";
                        }
                    }
                } catch (Exception ex) {
                    Logger.getLogger(CommentsServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                List<WebBusinessObject> employeeList = new ArrayList<>();
                if (selectedDepartment != null && !selectedDepartment.equals("all")) {
                    employeeList = userMgr.getEmployeeByDepartmentId(selectedDepartment, null, null);
                }
                if("all".equals(selectedDepartment)) {
                    selectedDepartment = allDepartmentIDs;
                }
                ArrayList<String> col = new ArrayList<>(request.getParameterMap().keySet());
                System.out.println("arrraaaa " + col.size());
                beginDate = request.getParameter("beginDate");
                endDate = request.getParameter("endDate");
                String currentOwnerID = request.getParameter("currentOwnerID");
                String sourceID = request.getParameter("sourceID");
                String issueStatus = request.getParameter("issueStatus");
                String noAppCmnt = request.getParameter("noAppCmnt");
                
                ArrayList<WebBusinessObject> data = new ArrayList<>();
                if (currentOwnerID != null || !selectedDepartment.isEmpty()) {
                    IssueByComplaintMgr issueByComplaintMgr = IssueByComplaintMgr.getInstance();
                    if(noAppCmnt !=null && noAppCmnt.equals("on")){
                        data = issueByComplaintMgr.getAllComplaintsByUserAndStatusAndSource(currentOwnerID,sourceID, beginDate, endDate, issueStatus, "on", selectedDepartment);
                    } else {
                        data = issueByComplaintMgr.getAllComplaintsByUserAndStatusAndSource(currentOwnerID,sourceID, beginDate, endDate, issueStatus, "off", selectedDepartment);
                    }
                    request.setAttribute("data", data);
                }
                
                try {
                    request.setAttribute("requestTypes", new ArrayList<>(ProjectMgr.getInstance().getOnArbitraryKey("RQ-TYPE", "key4")));
                } catch (Exception ex) {
                    request.setAttribute("requestTypes", new ArrayList<>());
                }
                
                securityUser = (SecurityUser) session.getAttribute("securityUser");
                request.setAttribute("employeeList", employeeList);
                request.setAttribute("departments", departments);
                request.setAttribute("selectedDepartment", selectedDepartment);
                request.setAttribute("employees", userMgr.getAllDistributionUsers((String) persistentUser.getAttribute("userId")));
                request.setAttribute("usersList", new ArrayList<>(userMgr.getCashedTable()));
                request.setAttribute("beginDate", beginDate);
                request.setAttribute("endDate", endDate);
                request.setAttribute("currentOwnerID", currentOwnerID);
                request.setAttribute("sourceID", sourceID);
                request.setAttribute("issueStatus", issueStatus);
                request.setAttribute("noAppCmnt", noAppCmnt);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 18:
                servedPage = "/docs/issue/update_issue_comments.jsp";
                
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 19:
                servedPage = "/docs/issue/update_issue_comments.jsp";
                String selectionDate = request.getParameter("issueDate");
                
                CommentsMgr commentsMgr = CommentsMgr.getInstance();
                userMgr = UserMgr.getInstance();
                
                ArrayList<WebBusinessObject> issueCommentsList = commentsMgr.getIssueComments(selectionDate);
                userMgr.cashData();
                Vector usersList = userMgr.getCashedTable();
                
                request.setAttribute("issueCommentsList", issueCommentsList);
                request.setAttribute("selectionDate", selectionDate);
                request.setAttribute("usersList", usersList);
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 20:
                servedPage = "/docs/requests/delete_request.jsp";
                searchByValue = request.getParameter("searchByValue");
                if (searchByValue != null) {
                    request.setAttribute("data", issueMgr.getClearErrorTasksByBusiness(searchByValue));
                }
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
                
            case 21:
                servedPage = "/DatabaseControllerServlet?op=deleteRequestForm";
                issueId = request.getParameter("issueId");
                if (issueId != null && !issueId.isEmpty()) {
                    try {
                        if (issueMgr.deleteAllIssueData(issueId)) {
                            request.setAttribute("status", "ok");
                        } else {
                            request.setAttribute("status", "fail");
                        }
                    } catch (SQLException ex) {
                        logger.error(ex);
                        request.setAttribute("status", "fail");
                    }
                }
                
                this.forward(servedPage, request, response);
                break;
            case 22:
                out = response.getWriter();
                wbo = new WebBusinessObject();
                issueMgr = IssueMgr.getInstance();
                wbo.setAttribute("status", "no");
                issueId = request.getParameter("issueId");
                if (issueId != null && !issueId.isEmpty()) {
                    try {
                        //For logging Withdraw Client
                        WebBusinessObject issueWbo = issueMgr.getOnSingleKey(issueId);
                        WebBusinessObject clientWbo;
                        ClientMgr clientMgr = ClientMgr.getInstance();
                        if (issueWbo != null) {
                            clientID = (String) issueWbo.getAttribute("clientId");
                            clientWbo = clientMgr.getOnSingleKey(clientID);
                        } else {
                            clientWbo = null;
                            clientID = null;
                        }
                        WebBusinessObject loggerWbo = new WebBusinessObject();
                        WebBusinessObject clientComplaintWbo = ClientComplaintsMgr.getInstance().getClientComplaintByIssueAndType(issueId, CRMConstants.CLIENT_COMPLAINT_TYPE_ORDER);
                        loggerWbo.setAttribute("objectXml", clientComplaintWbo != null ? clientComplaintWbo.getObjectAsXML() : issueWbo.getObjectAsXML());
                        loggerWbo.setAttribute("realObjectId", clientID == null ? "---" : clientID);
                        loggerWbo.setAttribute("userId", persistentUser.getAttribute("userId"));
                        loggerWbo.setAttribute("objectName", clientWbo != null ? clientWbo.getAttribute("clientNO") : "---");
                        loggerWbo.setAttribute("loggerMessage", "Withdraw Client");
                        loggerWbo.setAttribute("eventName", "Withdraw");
                        loggerWbo.setAttribute("objectTypeId", "1");
                        loggerWbo.setAttribute("eventTypeId", "5");
                        loggerWbo.setAttribute("ipForClient", getClientIpAddr(request));
                        securityUser = (SecurityUser) session.getAttribute("securityUser");
                        ArrayList<WebBusinessObject> distributionList = new ArrayList<>(DistributionListMgr.getInstance().getDistributionListByIssueID(issueId));
                        if (issueMgr.addWithdrawInfo((String) persistentUser.getAttribute("userId"), distributionList, clientWbo, loggerWbo)
                                && issueMgr.deleteAllIssueData(issueId) && AppointmentMgr.getInstance().deleteAllFutureAppointments(clientID)) {
                            wbo.setAttribute("status", "Ok");
                        }
                    } catch (SQLException ex) {
                        logger.error(ex);
                        request.setAttribute("status", "fail");
                    }
                }
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
                
            case 23:
                out = response.getWriter();
                wbo = new WebBusinessObject();
                IssueByComplaintMgr issueByComplaintMgr= IssueByComplaintMgr.getInstance();
                wbo.setAttribute("status", "no");
                String userId = request.getParameter("userId");
                if (userId != null && !userId.isEmpty()) {
                    ArrayList<WebBusinessObject> issuesLst =issueByComplaintMgr.getAllEmployeeComplaints(userId, null, null, null);
                    for (int i=0; i< issuesLst.size(); i++){
                        wbo = (WebBusinessObject)issuesLst.get(i);
                        try {
                            issueMgr.deleteAllIssueData((String)wbo.getAttribute("issue_id"));
                        } catch (SQLException ex) {
                            Logger.getLogger(DatabaseControllerServlet.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }
                }
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
            case 24:
                beginDate = request.getParameter("beginDate");
                endDate = request.getParameter("endDate");
                currentOwnerID = request.getParameter("currentOwnerID");
                sourceID = request.getParameter("sourceID");
                issueStatus = request.getParameter("issueStatus");
                noAppCmnt = request.getParameter("noAppCmnt");
                selectedDepartment = request.getParameter("departmentID");
                                
                data = new ArrayList<>();
                if (currentOwnerID != null || !selectedDepartment.isEmpty()) {
                    issueByComplaintMgr = IssueByComplaintMgr.getInstance();
                    if(noAppCmnt !=null && noAppCmnt.equals("on")){
                        data = issueByComplaintMgr.getAllComplaintsByUserAndStatusAndSource(currentOwnerID,sourceID, beginDate, endDate, issueStatus, "on", selectedDepartment);
                    } else {
                        data = issueByComplaintMgr.getAllComplaintsByUserAndStatusAndSource(currentOwnerID,sourceID, beginDate, endDate, issueStatus, "off", selectedDepartment);
                    }
                    request.setAttribute("data", data);
                    if (data != null && !data.isEmpty()) {
                        String headersExc[] = {"#", "رقم المتابعة", "اسم العميل", "النوع", "الموبايل", "الدولي", "المسؤل", "الموزع", "كود الطلب"};
                        String attributesExc[] = {"Number", "businessID", "customerName", "typeName", "clientMobile", "interPhone", "currentOwner", "senderName", "businessCompId"};
                        String dataTypesExc[] = {"", "String", "String", "String", "String", "String", "String", "String", "String"};
                        String[] headerStr = new String[1];
                        headerStr = new String[1];
                        headerStr[0] = "Withdraws";
                        HSSFWorkbook workBook = Tools.createExcelReport("Withdraws", headerStr, null, headersExc, attributesExc, dataTypesExc, data);
                        c = Calendar.getInstance();
                        java.util.Date fileDate = c.getTime();
                        sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                        sdf.applyPattern("yyyy-MM-dd");
                        String reportDate = sdf.format(fileDate);
                        String filename = "Withdraws" + reportDate;
                        fileDate = c.getTime();
                        SimpleDateFormat df = new SimpleDateFormat("dd-MM-yyyy");
                        reportDate = df.format(fileDate);
                        filename = "WithdrawsReq" + reportDate;
                        try (ServletOutputStream servletOutputStream = response.getOutputStream()) {
                            ByteArrayOutputStream bos = new ByteArrayOutputStream();
                            try {
                                workBook.write(bos);
                            } finally {
                                bos.close();
                            }

                            byte[] bytes = bos.toByteArray();
                            response.setContentType("application/vnd.ms-excel");
                            response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + ".xls\"");
                            response.setContentLength(bytes.length);
                            servletOutputStream.write(bytes, 0, bytes.length);
                            servletOutputStream.flush();
                        }
                    }
                }
                break;
            case 25:
                servedPage = "/docs/Adminstration/context_parameters.jsp";
                request.setAttribute("page", servedPage);
                this.forwardToServedPage(request, response);
                break;
            case 26:
                //drag from last appointment page 
                out = response.getWriter();
                wbo = new WebBusinessObject();
               
                 flag = "";
                flag = request.getParameter("flag");
                
                requestType = new String();
                employeeID = new String();
                selectedIssue = null;
                
                issueId = request.getParameter("issueId");
                //String clientID;
                if (issueId != null && !issueId.isEmpty()) {
                    try {
                        //For logging Withdraw Client
                        WebBusinessObject issueWbo = issueMgr.getOnSingleKey(issueId);
                        WebBusinessObject clientWbo;
                        ClientMgr clientMgr = ClientMgr.getInstance();
                        if (issueWbo != null) {
                            clientID = (String) issueWbo.getAttribute("clientId");
                            if (clientID == null || clientID.isEmpty()) {
                                clientID = (String) request.getParameter("clientId");
                            }
                            clientWbo = clientMgr.getOnSingleKey(clientID);
                        } else {
                            clientWbo = null;
                            clientID = null;
                        }
                        WebBusinessObject loggerWbo = new WebBusinessObject();
                        WebBusinessObject clientComplaintWbo = ClientComplaintsMgr.getInstance().getClientComplaintByIssueAndType(issueId, CRMConstants.CLIENT_COMPLAINT_TYPE_ORDER);
                        loggerWbo.setAttribute("objectXml", clientComplaintWbo != null ? clientComplaintWbo.getObjectAsXML() : issueWbo.getObjectAsXML());
                        loggerWbo.setAttribute("realObjectId", clientID == null ? "---" : clientID);
                        loggerWbo.setAttribute("userId", persistentUser.getAttribute("userId"));
                        loggerWbo.setAttribute("objectName", clientWbo != null ? clientWbo.getAttribute("clientNO") : "---");
                        loggerWbo.setAttribute("loggerMessage", "Withdraw Client");
                        loggerWbo.setAttribute("eventName", "Withdraw");
                        loggerWbo.setAttribute("objectTypeId", "1");
                        loggerWbo.setAttribute("eventTypeId", "5");
                        loggerWbo.setAttribute("ipForClient", getClientIpAddr(request));
                        String callStatus = (String) issueWbo.getAttribute("issueType");
                        String callType = (String) issueWbo.getAttribute("callType");
                        securityUser = (SecurityUser) session.getAttribute("securityUser");
                        ClientComplaintsMgr clientComplaintsMgr = ClientComplaintsMgr.getInstance();
                        String comment = request.getParameter("requestType");
                        ArrayList<WebBusinessObject> distributionList = new ArrayList<>(DistributionListMgr.getInstance().getDistributionListByIssueID(issueId));
                        if (issueMgr.addWithdrawInfo((String) persistentUser.getAttribute("userId"), distributionList, clientWbo, loggerWbo)
                                && issueMgr.deleteAllIssueData(issueId) && AppointmentMgr.getInstance().deleteAllFutureAppointments(clientID)) {
                            wbo.setAttribute("status", "ok");
                            if (request.getParameter("employeeID") != null) {
                                try {
                                    if (securityUser != null && securityUser.getCallcenterMode() != null && !securityUser.getCallcenterMode().equals("1")) {
                                        issueId = issueMgr.saveCallDataAuto(clientID, callType, callStatus, session, "issue", persistentUser);
                                    }
                                } catch (NoUserInSessionException | SQLException ex) {
                                    logger.error(ex);
                                }
                                try {
                                    if (issueId != null) {
                                        clientComplaintsMgr.createMailInBox((String) persistentUser.getAttribute("userId"),
                                                request.getParameter("employeeID"), issueId, "2", null,
                                                comment, comment, comment);
                                    }
                                } catch (SQLException ex) {
                                    logger.error(ex);
                                }
                            }
                        } else {
                            wbo.setAttribute("status", "fail");
                        }
                    } catch (SQLException ex) {
                        logger.error(ex);
                        request.setAttribute("status", "fail");
                    }
                } else {
                    requestType = request.getParameter("requestType");
                    employeeID = request.getParameter("employeeID");
                    selectedIssue = request.getParameterValues("selectedIssue");
                    
                }
                out.write(Tools.getJSONObjectAsString(wbo));
                break;
            default:
                logger.error("no oreration found ...");
        }
    }

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected int getOpCode(String opName) {
        if (opName.equalsIgnoreCase("updateDatabase")) {
            return 1;
        } else if (opName.equalsIgnoreCase("getRecreateAllViewForm")) {
            return 2;
        } else if (opName.equalsIgnoreCase("recreateAllView")) {
            return 3;
        } else if (opName.equalsIgnoreCase("checkForAllViews")) {
            return 4;
        } else if (opName.equalsIgnoreCase("currentDatabases")) {
            return 5;
        } else if (opName.equalsIgnoreCase("viewLog")) {
            return 6;
        } else if (opName.equalsIgnoreCase("confirmDeleteAllIssues")) {
            return 7;
        } else if (opName.equalsIgnoreCase("deleteAllIssues")) {
            return 8;
        } else if (opName.equals("SetExternalDatabase")) {
            return 9;
        } else if (opName.equals("saveExtDBConnection")) {
            return 10;
        } else if (opName.equals("showToDeleteUsers")) {
            return 11;
        } else if (opName.equals("DisjoinEmpAndMgr")) {
            return 12;
        } else if (opName.equals("clearErrorTasks")) {
            return 13;
        } else if (opName.equals("deleteTask")) {
            return 14;
        } else if (opName.equals("dragClientForm")) {
            return 15;
        } else if (opName.equals("dragClient")) {
            return 16;
        } else if (opName.equals("withdrawDistributions")) {
            return 17;
        } else if (opName.equals("sourceCorrection")) {
            return 18;
        } else if (opName.equals("getIssueComments")) {
            return 19;
        } else if (opName.equals("deleteRequestForm")) {
            return 20;
        } else if (opName.equals("deleteRequest")) {
            return 21;
        } else if (opName.equalsIgnoreCase("withdrewClientAjax")) {
            return 22;
        }
        else if (opName.equalsIgnoreCase("deleteRequestsAjax")) {
            return 23;
        } else if (opName.equals("withDrawFormExcel")) {
            return 24;
        } else if (opName.equals("getContextParameters")) {
            return 25;
        } else if (opName.equals("dragFromAppointment")) {
            return 26;
        }
        return 0;
    }

    private void manageStatement(String query, String blockIndex) throws Exception {
        query = StringUtils.trim(query);

        // set Wbo by parameters
        wbo = new WebBusinessObject();
        wbo.setAttribute("index", blockIndex);
        wbo.setAttribute("query", query);

        try {
            if (query != null && query.length() != 0) {
                databaseControllerMgr.execute(query);

                wbo.setAttribute("message", "Success");
                wbo.setAttribute("status", "ok");
                summary.addElement(wbo);
            }
        } catch (Exception ec) {
            noErrors = false;
            currentIndex--;
            wbo.setAttribute("message", ec.getMessage());
            wbo.setAttribute("status", "no");
            summary.addElement(wbo);
            throw ec;
        }
    }
}
