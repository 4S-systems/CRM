package com.maintenance.servlets;

import com.contractor.db_access.MaintainableMgr;
import com.maintenance.common.Tools;
import com.maintenance.db_access.ConfigAlterTasksPartsMgr;
import com.maintenance.db_access.ConfigureMainTypeMgr;
import com.maintenance.db_access.EmpBasicMgr;
import com.maintenance.db_access.EmployeeTypeMgr;
import com.maintenance.db_access.ItemsMgr;
import com.maintenance.db_access.QuantifiedMntenceMgr;
import com.maintenance.db_access.ScheduleMgr;
import com.maintenance.db_access.SupplierMgr;
import com.maintenance.db_access.UnitScheduleMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.common.SecurityUser;
import com.tracker.db_access.DepartmentMgr;
import com.tracker.db_access.IssueMgr;
import com.tracker.db_access.ProjectMgr;
import com.tracker.servlets.TrackerBaseServlet;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.silkworm.pagination.FilterCondition;
import com.silkworm.pagination.Operations;

public class SelectiveServlet extends TrackerBaseServlet {

    MaintainableMgr maintainableMgr = MaintainableMgr.getInstance();
    SupplierMgr supplierMgr = SupplierMgr.getInstance();
    DepartmentMgr departmentMgr = DepartmentMgr.getInstance();
    EmpBasicMgr empBasicMgr = EmpBasicMgr.getInstance();
    EmployeeTypeMgr employeeTypeMgr = EmployeeTypeMgr.getInstance();
    WebBusinessObject wbo = new WebBusinessObject();
    ItemsMgr itemsMgr = ItemsMgr.getInstance();
    ScheduleMgr scheduleMgr = ScheduleMgr.getInstance();
    SecurityUser securityUser;
    Vector vecItems = new Vector();
    Vector itemList = new Vector();
    String unitName, brandName, formName, unitCode, brandCode, goToViewEquipment, reload, reloadUrl;

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }

    @Override
    public void destroy() {
    }

    @Override
    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        super.processRequest(request, response);
        HttpSession session = request.getSession();
        String langCode = (String) session.getAttribute("currentMode");
        switch (operation) {
            case 1:
                unitName = request.getParameter("unitName");
                formName = request.getParameter("formName");
                String strSites = request.getParameter("sites");
                strSites = strSites.trim();
                String[] listSites = strSites.split(" ");
                unitName = Tools.getRealChar(unitName);

                Vector listEquipments = new Vector();
                int count = 0;
                String url = "SelectiveServlet?op=ListUnits";
                maintainableMgr = MaintainableMgr.getInstance();

                if (unitName != null && !unitName.equals("")) {
                    for (int i = 0; i < listSites.length; i++) {
                        listEquipments = mergerVectors(listEquipments, maintainableMgr.getEquipBySubNameAndSiteId(listSites[i], unitName));
                    }
                } else {
                    for (int i = 0; i < listSites.length; i++) {
                        listEquipments = mergerVectors(listEquipments, maintainableMgr.getEquipBySiteId(listSites[i]));
                    }
                }
                String tempcount = (String) request.getParameter("count");
                if (tempcount != null) {
                    count = Integer.parseInt(tempcount);
                }
                Vector subListEquipments = new Vector();
                int index = (count + 1) * 10;
                if (listEquipments.size() < index) {
                    index = listEquipments.size();
                }
                for (int i = count * 10; i < index; i++) {
                    wbo = (WebBusinessObject) listEquipments.get(i);
                    subListEquipments.add(wbo);
                }
                float noOfLinks = listEquipments.size() / 10f;
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
                servedPage = "/docs/Selective/equipments_list.jsp";
                request.setAttribute("count", "" + count);
                request.setAttribute("noOfLinks", "" + links);
                request.setAttribute("fullUrl", url);
                request.setAttribute("url", url);
                request.setAttribute("unitName", unitName);
                request.setAttribute("formName", formName);
                request.setAttribute("sites", strSites);
                request.setAttribute("data", subListEquipments);
                request.setAttribute("page", servedPage);
                this.forward(servedPage, request, response);
                break;

            case 2:
                unitName = request.getParameter("unitName");
                formName = request.getParameter("formName");
                unitName = Tools.getRealChar(unitName);

                count = 0;
                url = "SelectiveServlet?op=ListUnits";
                maintainableMgr = MaintainableMgr.getInstance();
                listEquipments = new Vector();
                if (unitName != null && !unitName.equals("")) {
                    listEquipments = maintainableMgr.getEquipBySubName(unitName);
                } else {
                    try {
                        listEquipments = maintainableMgr.getOnArbitraryDoubleKey("1", "key3", "0", "key5");
                    } catch (Exception ex) {
                        logger.error(ex.getMessage());
                    }
                }
                tempcount = (String) request.getParameter("count");
                if (tempcount != null) {
                    count = Integer.parseInt(tempcount);
                }
                subListEquipments = new Vector();
                index = (count + 1) * 10;
                if (listEquipments.size() < index) {
                    index = listEquipments.size();
                }
                for (int i = count * 10; i < index; i++) {
                    wbo = (WebBusinessObject) listEquipments.get(i);
                    subListEquipments.add(wbo);
                }
                noOfLinks = listEquipments.size() / 10f;
                temp = "" + noOfLinks;
                intNo = Integer.parseInt(temp.substring(temp.indexOf(".") + 1, temp.length()));
                links = (int) noOfLinks;
                if (intNo > 0) {
                    links++;
                }
                if (links == 1) {
                    links = 0;
                }
                session.removeAttribute("CategoryID");
                servedPage = "/docs/Selective/equipments_list.jsp";
                request.setAttribute("count", "" + count);
                request.setAttribute("noOfLinks", "" + links);
                request.setAttribute("fullUrl", url);
                request.setAttribute("url", url);
                request.setAttribute("unitName", unitName);
                request.setAttribute("formName", formName);
                request.setAttribute("data", subListEquipments);
                request.setAttribute("page", servedPage);
                this.forward(servedPage, request, response);
                break;

            case 3:
                servedPage = "/docs/Selective/select_multi_items.jsp";
                String efficient = (String) request.getParameter("efficient");
                // get Spare Parts
                Tools.setRequestBySparePartsInfo(request, 10);

                request.setAttribute("spareName", request.getParameter("spareName"));
                request.setAttribute("attachOn", request.getParameter("attachOn"));
                request.setAttribute("efficient", efficient);
                this.forward(servedPage, request, response);
                break;

            case 4:
                String empNO = request.getParameter("empNO");
                String searchType = request.getParameter("searchType");
                String empName = (String) request.getParameter("empName");
                formName = (String) request.getParameter("formName");

                empName = Tools.getRealChar(empName);

                if (langCode != null) {
                    langCode = langCode.toUpperCase();
                }

                Vector empViewTemp = new Vector();
                count = 0;
                url = "SelectiveServlet?op=listEmpViews";

                if (searchType.equalsIgnoreCase("byName")) {
                    if (empName != null && !empName.equals("")) {
                        empViewTemp = empBasicMgr.getEmpViewNotInEmployee(empName, "name", langCode);
                    } else {
                        empViewTemp = empBasicMgr.getAllEmpViewNotInEmployee();
                    }
                } else if (searchType.equalsIgnoreCase("byCode")) {
                    if (empName != null && !empName.equals("")) {
                        empViewTemp = empBasicMgr.getEmpViewNotInEmployee(empName, "code", langCode);
                    } else {
                        empViewTemp = empBasicMgr.getAllEmpViewNotInEmployee();
                    }
                } else {
                    empViewTemp = empBasicMgr.getCashedTable();
                }

                tempcount = (String) request.getParameter("count");
                if (tempcount != null) {
                    count = Integer.parseInt(tempcount);
                }

                Vector empViewVec = new Vector();

                index = (count + 1) * 20;

                if (empViewTemp.size() < index) {
                    index = empViewTemp.size();
                }

                for (int i = count * 20; i < index; i++) {
                    wbo = (WebBusinessObject) empViewTemp.get(i);
                    empViewVec.add(wbo);
                }

                noOfLinks = empViewTemp.size() / 20f;
                temp = "" + noOfLinks;
                intNo = Integer.parseInt(temp.substring(temp.indexOf(".") + 1, temp.length()));
                links = (int) noOfLinks;
                if (intNo > 0) {
                    links++;
                }
                if (links == 1) {
                    links = 0;
                }

                servedPage = "/docs/Selective/emp_view_list.jsp";
                request.setAttribute("count", "" + count);
                request.setAttribute("noOfLinks", "" + links);
                request.setAttribute("fullUrl", url);
                request.setAttribute("url", url);
                request.setAttribute("empName", empName);
                request.setAttribute("searchType", searchType);
                request.setAttribute("empNO", empNO);
                request.setAttribute("formName", formName);
                request.setAttribute("defaultDepartment", departmentMgr.getDefaultDepartment());
                request.setAttribute("defaultEmployeeType", employeeTypeMgr.getDefaultDepartment());
                request.setAttribute("data", empViewVec);
                request.setAttribute("page", servedPage);

                this.forward(servedPage, request, response);
                break;

            case 5:
                int Size = 0;
                securityUser = (SecurityUser) session.getAttribute("securityUser");

                unitName = request.getParameter("unitName");
                unitCode = request.getParameter("unitCode");
                formName = request.getParameter("formName");
                reload = request.getParameter("reload");
                goToViewEquipment = request.getParameter("goToViewEquipment");
                ProjectMgr projectMgr = ProjectMgr.getInstance();
                String siteId = securityUser.getSiteId();
                List projectsList = securityUser.getUserProjects();
                String[] userProjectsList = new String[projectsList.size()];
                for(int i = 0 ; i< projectsList.size();i++){
                    userProjectsList[i] =((WebBusinessObject)projectsList.get(i)).getAttribute("projectID").toString();
                }
                siteId = Tools.concatenation(userProjectsList, ",") ;
                
                listEquipments = new Vector();
                count = 0;
                url = "SelectiveServlet?op=listEquipmentsAndViewEquipment";
                maintainableMgr = MaintainableMgr.getInstance();

                if (unitName != null && !unitName.equals("") && !unitName.equals("null")) {
                    unitName = Tools.getRealChar(unitName);
                }

                try {
                    if (unitName != null && !unitName.equals("") && !unitName.equals("null")) {
                        listEquipments = maintainableMgr.getEquipBySubNameOrCode(unitName, siteId, "name");
                    } else if (unitCode != null && !unitCode.equals("") && !unitCode.equals("null")) {
                        listEquipments = maintainableMgr.getEquipBySubNameOrCode(unitCode, siteId, "code");
                    } else {
                        listEquipments = maintainableMgr.getEquipBySiteId(siteId);
                    }
                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }

                Size = listEquipments.size();
                tempcount = (String) request.getParameter("count");
                if (tempcount != null) {
                    count = Integer.parseInt(tempcount);
                }

                subListEquipments = new Vector();
                index = (count + 1) * 10;


                if (listEquipments.size() < index) {
                    index = listEquipments.size();
                }
                for (int i = count * 10; i < index; i++) {
                    wbo = (WebBusinessObject) listEquipments.get(i);
                    subListEquipments.add(wbo);
                }

                noOfLinks = listEquipments.size() / 10f;
                temp = "" + noOfLinks;
                intNo = Integer.parseInt(temp.substring(temp.indexOf(".") + 1, temp.length()));
                links = (int) noOfLinks;
                if (intNo > 0) {
                    links++;
                }
                if (links == 1) {
                    links = 0;
                }

                if (goToViewEquipment != null && goToViewEquipment.equalsIgnoreCase("ok")) {
                    servedPage = "/docs/Selective/equipments_list_view.jsp";
                } else {
                    servedPage = "/docs/Selective/equipments_list.jsp";
                }

                try {
                    if (request.getParameter("eqpByRateType") != null) {
                        servedPage = "/docs/Selective/equipments_list_type.jsp";
                    }
                } catch (Exception e) {
                }

                // to reload the parant
                if (reload != null && reload.equals("ok")) {
                    reloadUrl = request.getParameter("reloadUrl");
                    request.setAttribute("reload", "ok");
                    request.setAttribute("reloadUrl", reloadUrl);
                    url += "&reload=" + reload + "&reloadUrl=" + reloadUrl;
                }


                request.setAttribute("count", "" + count);
                request.setAttribute("noOfLinks", "" + links);
                request.setAttribute("fullUrl", url);
                request.setAttribute("url", url);
                request.setAttribute("unitName", unitName);
                request.setAttribute("unitCode", unitCode);
                request.setAttribute("formName", formName);
                request.setAttribute("size", "" + Size);
                request.setAttribute("data", subListEquipments);
                request.setAttribute("page", servedPage);

                this.forward(servedPage, request, response);
                break;

            case 6:
                /*servedPage = "/docs/Selective/select_config_items.jsp";
                String newissue = request.getParameter("configissueid");

                efficient = (String)request.getParameter("efficient");
                QuantifiedMntenceMgr ListItems = QuantifiedMntenceMgr.getInstance();
                Vector itemListTemp = new Vector();
                ListItems = QuantifiedMntenceMgr.getInstance();
                UnitScheduleMgr usMgr = UnitScheduleMgr.getInstance();
                IssueMgr issueMgr = IssueMgr.getInstance();
                WebBusinessObject weboIssue = (WebBusinessObject)issueMgr.getOnSingleKey(newissue);
                String uSID = issueMgr.getOnSingleKey(newissue).getAttribute("unitScheduleID").toString();

                itemListTemp = ListItems.getSpecialItemSchedule(uSID, "0");
                WebBusinessObject web = usMgr.getOnSingleKey(uSID);
                Vector configitemList = new Vector();

                String eID = web.getAttribute("periodicId").toString();
                if (eID.equalsIgnoreCase("1") || eID.equalsIgnoreCase("2")) {
                configitemList = ListItems.getSpecialItemSchedule(uSID, "0");
                } else {
                if (itemListTemp.size() == 0) {
                ConfigureMainTypeMgr itemsList = ConfigureMainTypeMgr.getInstance();
                configitemList = itemsList.getConfigItemBySchedule(eID);
                } else {
                configitemList = itemListTemp;
                }
                }

                count = 0;
                url = "SelectiveServlet?op=selectConfigSpareParts";
                tempcount = request.getParameter("count");
                if (tempcount != null) {
                count = Integer.parseInt(tempcount);
                }
                index = (count+1)*20;

                if(vecItems.size() < index)
                index = vecItems.size();
                for (int i = count*20; i <index ; i++) {
                wbo = (WebBusinessObject) vecItems.get(i);
                itemList.add(wbo);
                }

                noOfLinks = vecItems.size() / 20f;
                temp = "" + noOfLinks;
                intNo = Integer.parseInt(temp.substring(temp.indexOf(".") + 1, temp.length()));
                links = (int) noOfLinks;
                if(intNo > 0)
                links++;
                if(links == 1)
                links = 0;

                request.setAttribute("data", configitemList);
                request.setAttribute("count",""+count);
                request.setAttribute("noOfLinks",""+links);
                request.setAttribute("fullUrl", url);
                request.setAttribute("url", url);
                // request.setAttribute("data", itemList);
                request.setAttribute("efficient", efficient);
                this.forward(servedPage,request, response);
                break;*/
                servedPage = "/docs/Selective/select_config_items.jsp";
                String newissue = request.getParameter("configissueid");

                efficient = (String) request.getParameter("efficient");
                QuantifiedMntenceMgr ListItems = QuantifiedMntenceMgr.getInstance();
                Vector itemListTemp = new Vector();
                ListItems = QuantifiedMntenceMgr.getInstance();
                UnitScheduleMgr usMgr = UnitScheduleMgr.getInstance();
                IssueMgr issueMgr = IssueMgr.getInstance();
                WebBusinessObject weboIssue = (WebBusinessObject) issueMgr.getOnSingleKey(newissue);
                String uSID = issueMgr.getOnSingleKey(newissue).getAttribute("unitScheduleID").toString();

                itemListTemp = ListItems.getSpecialItemSchedule(uSID, "0");
                WebBusinessObject web = usMgr.getOnSingleKey(uSID);
                Vector configitemList = new Vector();

                /*******************************/
                Vector saparPartscodes = new Vector();
                Vector saparPartsQunt = new Vector();



                String eID = web.getAttribute("periodicId").toString();
                if (eID.equalsIgnoreCase("1") || eID.equalsIgnoreCase("2")) {
                    configitemList = ListItems.getSpecialItemSchedule(uSID, "0");
                } else {
                    if (itemListTemp.size() == 0) {
                        ConfigureMainTypeMgr itemsList = ConfigureMainTypeMgr.getInstance();
                        configitemList = itemsList.getConfigItemBySchedule(eID);
                    } else {
                        configitemList = itemListTemp;
                    }
                }
                int x = 1;
                WebBusinessObject partsWbo = new WebBusinessObject();
                if (configitemList != null) {

                    String[] parts = request.getParameter("parts").split("/");
                    /*String[] partsCodes = request.getParameterValues("code_o");
                    String[] partsQunts = request.getParameterValues("qun_o");*/
                    if (parts != null) {
                        if (parts.length > 0) {
                            String[] partsCodes = parts[0].split(",");
                            String[] partsCodesTemp = null;
                            String[] partsQunts = parts[1].split(",");
                            String itemQuantity = new String();

                            startHere:
                            for (int i = 0; i < configitemList.size(); i++) {
                                String quantity = new String();
                                String code = new String();
                                partsWbo = (WebBusinessObject) configitemList.get(i);
                                code = (String) partsWbo.getAttribute("itemId");
                                quantity = (String) partsWbo.getAttribute("quantityStatus");
                                itemQuantity = (String) partsWbo.getAttribute("itemQuantity");
                                if (partsCodes != null) {
                                    if (partsCodes.length > 0) {

                                        for (int j = 0; j < partsCodes.length; j++) {
                                            if (partsCodes[j].equals(code)) {
                                                configitemList.remove(i);
                                                partsCodes = RemoveItemFromArray(partsCodes, code);
                                                i = i - 1;
                                                break;
                                            } else {
                                                if (Integer.parseInt(quantity) > 0) {
                                                    partsWbo.setAttribute("itemQuantity", quantity);
                                                    partsCodes = RemoveItemFromArray(partsCodes, code);
                                                    break;
                                                } else {
                                                    configitemList.remove(i);
                                                    partsCodes = RemoveItemFromArray(partsCodes, code);
                                                    i = i - 1;
                                                    break;
                                                }
                                            }
                                        }

                                    } else if (Integer.parseInt(quantity) > 0) {
                                        partsWbo.setAttribute("itemQuantity", quantity);
                                    } else {
                                        configitemList.remove(i);
                                        i = i - 1;
                                    }
                                }
                            }
                        } else {
                            for (int i = 0; i < configitemList.size(); i++) {
                                String quantity = new String();
                                String code = new String();
                                partsWbo = (WebBusinessObject) configitemList.get(i);
                                code = (String) partsWbo.getAttribute("itemId");
                                quantity = (String) partsWbo.getAttribute("quantityStatus");
                                String itemQuantity = (String) partsWbo.getAttribute("itemQuantity");

                                if (Integer.parseInt(quantity) > 0) {
                                    partsWbo.setAttribute("itemQuantity", quantity);
                                } else {
                                    configitemList.remove(i);
                                    i = i - 1;
                                }
                            }

                        }
                    } else {
                        for (int i = 0; i < configitemList.size(); i++) {
                            String quantity = new String();
                            String code = new String();
                            partsWbo = (WebBusinessObject) configitemList.get(i);
                            code = (String) partsWbo.getAttribute("itemId");
                            quantity = (String) partsWbo.getAttribute("quantityStatus");
                            String itemQuantity = (String) partsWbo.getAttribute("itemQuantity");

                            if (Integer.parseInt(quantity) > 0) {
                                partsWbo.setAttribute("itemQuantity", quantity);
                            } else {
                                configitemList.remove(i);
                                i = i - 1;
                            }
                        }

                    }
                }

                count = 0;
                url = "SelectiveServlet?op=selectConfigSpareParts";
                tempcount = request.getParameter("count");
                if (tempcount != null) {
                    count = Integer.parseInt(tempcount);
                }
                index = (count + 1) * 20;

                if (vecItems.size() < index) {
                    index = vecItems.size();
                }
                for (int i = count * 20; i < index; i++) {
                    wbo = (WebBusinessObject) vecItems.get(i);
                    itemList.add(wbo);
                }

                noOfLinks = vecItems.size() / 20f;
                temp = "" + noOfLinks;
                intNo = Integer.parseInt(temp.substring(temp.indexOf(".") + 1, temp.length()));
                links = (int) noOfLinks;
                if (intNo > 0) {
                    links++;
                }
                if (links == 1) {
                    links = 0;
                }

                request.setAttribute("data", configitemList);
                request.setAttribute("count", "" + count);
                request.setAttribute("noOfLinks", "" + links);
                request.setAttribute("fullUrl", url);
                request.setAttribute("url", url);
                // request.setAttribute("data", itemList);
                request.setAttribute("efficient", efficient);
                this.forward(servedPage, request, response);
                break;
            case 7:

                String scheduleId = (String) request.getParameter("scheduleId");
                WebBusinessObject scheduleWbo = scheduleMgr.getOnSingleKey(scheduleId);
                servedPage = "/docs/Selective/schedule_data.jsp";
                request.setAttribute("scheduleWbo", scheduleWbo);
                request.setAttribute("page", servedPage);
                this.forward(servedPage, request, response);
                break;

            case 8:
                String scheduleName = request.getParameter("scheduleName");
                String scheduleOn = request.getParameter("scheduleOn");
                formName = request.getParameter("formName");
                Vector category = new Vector();
                Vector categoryTemp = new Vector();
                count = 0;
                url = "SelectiveServlet?op=listSchedules";

                String realName = com.maintenance.common.Tools.getRealChar(scheduleName);

                if (scheduleName != null && !scheduleName.equals("")) {
                    categoryTemp = scheduleMgr.getSchBySubName(realName, scheduleOn);
                } else {
                    categoryTemp = scheduleMgr.getSchByScheduleOn(scheduleOn);
                }

                tempcount = (String) request.getParameter("count");
                if (tempcount != null) {
                    count = Integer.parseInt(tempcount);
                }
                index = (count + 1) * 10;
                if (categoryTemp.size() < index) {
                    index = categoryTemp.size();
                }

                for (int i = count * 10; i < index; i++) {
                    category.add((WebBusinessObject) categoryTemp.get(i));
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

                servedPage = "/docs/Selective/schedules_list.jsp";
                request.setAttribute("count", "" + count);
                request.setAttribute("noOfLinks", "" + links);
                request.setAttribute("totalScheduleNumbers", categoryTemp.size());
                request.setAttribute("fullUrl", url);
                request.setAttribute("url", url);
                request.setAttribute("scheduleName", scheduleName);
                request.setAttribute("scheduleOn", scheduleOn);
                request.setAttribute("formName", formName);
                request.setAttribute("data", category);
                request.setAttribute("page", servedPage);
                this.forward(servedPage, request, response);
                break;

            case 9:
                securityUser = (SecurityUser) session.getAttribute("securityUser");
                brandName = request.getParameter("brandName");
                brandCode = request.getParameter("brandCode");
                formName = request.getParameter("formName");
                reload = request.getParameter("reload");
                goToViewEquipment = request.getParameter("goToViewEquipment");

                Vector brandsSubList = new Vector();
                Vector brandsList = new Vector();
                count = 0;
                url = "SelectiveServlet?op=listBrandsAndViewEquipment";
                maintainableMgr = MaintainableMgr.getInstance();

                if (brandName != null && !brandName.equals("") && !brandName.equals("null")) {
                    brandName = Tools.getRealChar(brandName);

                }

                try {

                    if (brandName != null && !brandName.equals("") && !brandName.equals("null")) {
                        brandsList = maintainableMgr.getBrandBySubNameOrCode(brandName, securityUser.getBranchesAsArray(), "name");

                    } else if (brandCode != null && !brandCode.equals("") && !brandCode.equals("null")) {
                        brandsList = maintainableMgr.getBrandBySubNameOrCode(brandCode, securityUser.getBranchesAsArray(), "code");

                    } else {
                        brandsList = maintainableMgr.getRootNodes();

                    }

                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }

                tempcount = (String) request.getParameter("count");
                if (tempcount != null) {
                    count = Integer.parseInt(tempcount);
                }


                index = (count + 1) * 10;

                if (brandsList.size() < index) {
                    index = brandsList.size();
                }
                for (int i = count * 10; i < index; i++) {
                    wbo = (WebBusinessObject) brandsList.get(i);
                    brandsSubList.add(wbo);
                }

                noOfLinks = brandsList.size() / 10f;
                temp = "" + noOfLinks;
                intNo = Integer.parseInt(temp.substring(temp.indexOf(".") + 1, temp.length()));
                links = (int) noOfLinks;

                if (intNo > 0) {
                    links++;
                }

                if (links == 1) {
                    links = 0;
                }

                if (goToViewEquipment != null && goToViewEquipment.equalsIgnoreCase("ok")) {
                    servedPage = "/docs/Selective/brands_list_view.jsp";

                } else {
                    servedPage = "/docs/Selective/brands_list.jsp";

                }

                // to reload the parant
                if (reload != null && reload.equals("ok")) {
                    reloadUrl = request.getParameter("reloadUrl");
                    request.setAttribute("reload", "ok");
                    request.setAttribute("reloadUrl", reloadUrl);
                    url += "&reload=" + reload + "&reloadUrl=" + reloadUrl;
                }

                request.setAttribute("count", "" + count);
                request.setAttribute("noOfLinks", "" + links);
                request.setAttribute("fullUrl", url);
                request.setAttribute("url", url);
                request.setAttribute("brandName", brandName);
                request.setAttribute("brandCode", brandCode);
                request.setAttribute("formName", formName);
                request.setAttribute("data", brandsSubList);
                request.setAttribute("page", servedPage);

                this.forward(servedPage, request, response);
                break;

            case 10:
                Size = 0;
                securityUser = (SecurityUser) session.getAttribute("securityUser");
                unitName = request.getParameter("unitName");
                unitCode = request.getParameter("unitCode");
                formName = request.getParameter("formName");
                reload = request.getParameter("reload");
                goToViewEquipment = request.getParameter("goToViewEquipment");
                String[] siteArr = request.getParameter("siteArr").split(",");
                listEquipments = new Vector();
                count = 0;
                url = "SelectiveServlet?op=listEquipmentsBySite";
                maintainableMgr = MaintainableMgr.getInstance();

                try {
                    if (unitName != null && !unitName.equals("") && !unitName.equals("null")) {
                        unitName = Tools.getRealChar(unitName);
                        listEquipments = maintainableMgr.getEquipBySubNameOrCodeAndSites(unitName, securityUser.getSiteId(), "name", Tools.arrayToString(siteArr, ","));

                    } else if (unitCode != null && !unitCode.equals("") && !unitCode.equals("null")) {
                        listEquipments = maintainableMgr.getEquipBySubNameOrCodeAndSites(unitCode, securityUser.getSiteId(), "code", Tools.arrayToString(siteArr, ","));

                    } else {
                        listEquipments = maintainableMgr.getEquipBySites(Tools.arrayToString(siteArr, ","));

                    }

                } catch (Exception ex) {
                    logger.error(ex.getMessage());
                }

                Size = listEquipments.size();
                tempcount = (String) request.getParameter("count");
                if (tempcount != null) {
                    count = Integer.parseInt(tempcount);
                }

                subListEquipments = new Vector();
                index = (count + 1) * 10;


                if (listEquipments.size() < index) {
                    index = listEquipments.size();
                }
                for (int i = count * 10; i < index; i++) {
                    wbo = (WebBusinessObject) listEquipments.get(i);
                    subListEquipments.add(wbo);
                }

                noOfLinks = listEquipments.size() / 10f;
                temp = "" + noOfLinks;
                intNo = Integer.parseInt(temp.substring(temp.indexOf(".") + 1, temp.length()));
                links = (int) noOfLinks;
                if (intNo > 0) {
                    links++;
                }
                if (links == 1) {
                    links = 0;
                }

                if (goToViewEquipment != null && goToViewEquipment.equalsIgnoreCase("ok")) {
                    servedPage = "/docs/Selective/equipments_list_view.jsp";
                } else {
                    servedPage = "/docs/Selective/equipments_list_by_sites.jsp";
                }

                try {
                    if (request.getParameter("eqpByRateType") != null) {
                        servedPage = "/docs/Selective/equipments_list_type.jsp";
                    }
                } catch (Exception e) {
                }

                // to reload the parant
                if (reload != null && reload.equals("ok")) {
                    reloadUrl = request.getParameter("reloadUrl");
                    request.setAttribute("reload", "ok");
                    request.setAttribute("reloadUrl", reloadUrl);
                    url += "&reload=" + reload + "&reloadUrl=" + reloadUrl;
                }

                request.setAttribute("count", "" + count);
                request.setAttribute("noOfLinks", "" + links);
                request.setAttribute("fullUrl", url);
                request.setAttribute("url", url);
                request.setAttribute("siteArr", Tools.arrayToString(siteArr, ","));
                request.setAttribute("unitName", unitName);
                request.setAttribute("unitCode", unitCode);
                request.setAttribute("formName", formName);
                request.setAttribute("size", "" + Size);
                request.setAttribute("data", subListEquipments);
                request.setAttribute("page", servedPage);

                this.forward(servedPage, request, response);
                break;

            case 11:
                servedPage = "/docs/Selective/select_alter_items.jsp";
                // get Spare Parts
                String taskId= (String) request.getParameter("taskId");
                String mainItemId = (String) request.getParameter("mainItemId");
                ConfigAlterTasksPartsMgr configAlterTasksPartsMgr = ConfigAlterTasksPartsMgr.getInstance();
                Vector itemsByTaskV = new Vector();
                try {
                    itemsByTaskV = configAlterTasksPartsMgr.getOnArbitraryDoubleKey(taskId, "key1", mainItemId, "key2");

                } catch (SQLException ex) {
                    Logger.getLogger(SelectiveServlet.class.getName()).log(Level.SEVERE, null, ex);
                } catch (Exception ex) {
                    Logger.getLogger(SelectiveServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                request.setAttribute("taskId", taskId);
                request.setAttribute("mainItemId", mainItemId);
                request.setAttribute("data", itemsByTaskV);
                this.forward(servedPage, request, response);
                break;
                
            case 12:
                servedPage = "/docs/equipment/unit_list.jsp";
                String fieldValue = request.getParameter("fieldValue");
                com.silkworm.pagination.Filter filter = new com.silkworm.pagination.Filter();
                String selectionType = request.getParameter("selectionType");
                ArrayList<FilterCondition> conditions = new ArrayList<FilterCondition>();

                filter = Tools.getPaginationInfo(request, response);

                conditions.addAll(filter.getConditions());

                // add conditions
                if(fieldValue != null && !fieldValue.equals("")) {
                    fieldValue = Tools.getRealChar((String) fieldValue);
                    conditions.add(new FilterCondition("UNIT_NAME", fieldValue, Operations.LIKE));

                }

                conditions.add(new FilterCondition("IS_MAINTAINABLE", "1", Operations.EQUAL));
                conditions.add(new FilterCondition("IS_DELETED", "0", Operations.EQUAL));

                filter.setConditions(conditions);
                List<WebBusinessObject> unitList = new ArrayList<WebBusinessObject>(0);

                // grab unit list
                try {
                    unitList = maintainableMgr.paginationEntity(filter);

                } catch (Exception e) {
                    System.out.println(e);
                }

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
                request.setAttribute("unitList", unitList);
                this.forward(servedPage, request, response);
                break;

            default:
                System.out.println("No operation was matched");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Search Servlet";
    }

    @Override
    protected int getOpCode(String opName) {
        if (opName.equals("ListUnits")) {
            return 1;
        }
        if (opName.equals("listAllUnit")) {
            return 2;
        }
        if (opName.equals("selectMultiSpareParts")) {
            return 3;
        }
        if (opName.equals("listEmpViews")) {
            return 4;
        }
        if (opName.equals("listEquipmentsAndViewEquipment")) {
            return 5;
        }
        if (opName.equals("selectConfigSpareParts")) {
            return 6;
        }
        if (opName.equals("viewScheduleData")) {
            return 7;
        }
        if (opName.equals("listSchedules")) {
            return 8;
        }
        if (opName.equals("listBrandsAndViewEquipment")) {
            return 9;
        }
        if (opName.equals("listEquipmentsBySite")) {
            return 10;
        }
        if (opName.equals("listAlterParts")) {
            return 11;
        }
        if (opName.equals("listEquipments")) {
            return 12;
        }
       
        return 0;
    }

    public Vector mergerVectors(Vector largeVector, Vector smallVector) {
        for (int i = 0; i < smallVector.size(); i++) {
            largeVector.add((WebBusinessObject) smallVector.get(i));
        }
        return largeVector;
    }

    public static String[] RemoveItemFromArray(String[] array, int index) {
        ArrayList list = CreateStringList(array);
        list.remove(index);
        return ConvertToStringArray(list);
    }

    public static String[] RemoveItemFromArray(String[] array, String item) {
        ArrayList list = CreateStringList(array);
        list.remove(item);
        return ConvertToStringArray(list);
    }

    public static String[] ConvertToStringArray(ArrayList list) {
        return (String[]) list.toArray(new String[0]);
    }

    public static ArrayList<String> CreateStringList(String... values) {
        ArrayList<String> results = new ArrayList<String>();
        Collections.addAll(results, values);
        return results;
    }

    public static int totalQuantity(String[] codes, String[] values, String code) {
        int quant = 0;

        for (int i = 0; i < codes.length; i++) {
            if (codes[i].equals(code)) {

                quant += Integer.parseInt(values[i]);
            }
        }
        return quant;
    }
}
