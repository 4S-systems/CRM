/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.crm.common;

import com.clients.db_access.ClientComplaintsMgr;
import com.clients.db_access.ClientMgr;
import com.clients.db_access.ClientProductMgr;
import com.crm.db_access.EmployeesLoadsGroupSummaryMgr;
import com.silkworm.Exceptions.NoUserInSessionException;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.common.SecurityUser;
import com.tracker.db_access.IssueMgr;
import com.tracker.db_access.ProjectMgr;
import java.sql.SQLException;
import java.util.List;
import java.util.Vector;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.apache.log4j.Logger;

/**
 *
 * @author walid
 */
public class AutoPilotFeature {

    private final Logger logger;

    public AutoPilotFeature() {
        this.logger = Logger.getLogger(AutoPilotFeature.class);
    }

    public void autoPilot(String clientId, HttpServletRequest request, WebBusinessObject persistentUser) {
        HttpSession session = request.getSession();
        SecurityUser securityUser = (SecurityUser) request.getSession().getAttribute("securityUser");
        ClientComplaintsMgr clientComplaintsMgr = ClientComplaintsMgr.getInstance();
        EmployeesLoadsGroupSummaryMgr loads = EmployeesLoadsGroupSummaryMgr.getInstance();
        IssueMgr issueMgr = IssueMgr.getInstance();
        ClientMgr clientMgr = ClientMgr.getInstance();
        WebBusinessObject wbo;

        String issueId = null;
        String freeEmployeeId;
        String comment = "عميل جديد";
        String subject = "عميل جديد";
        String notes = "عميل جديد";

        //Begin Automatically generate Record Number
        WebBusinessObject clientWbo = clientMgr.getOnSingleKey(clientId);
        try {
            if (securityUser != null && securityUser.getCallcenterMode() != null && !securityUser.getCallcenterMode().equals("1")) {
                String callStatus = null;
                String callType = null;
                if (securityUser.getCallcenterMode().equals("2")) {
                    callStatus = "incoming";
                    callType = "call";
                } else if (securityUser.getCallcenterMode().equals("3")) {
                    callStatus = "out_call";
                    callType = "call";
                } else if (securityUser.getCallcenterMode().equals("4")) {
                    callStatus = "incoming";
                    callType = "meeting";
                } else if (securityUser.getCallcenterMode().equals("5")) {
                    callStatus = "out_call";
                    callType = "meeting";
                } else if (securityUser.getCallcenterMode().equals("6")) {
                    callStatus = "incoming";
                    callType = "internet";
                }

                issueId = issueMgr.saveCallDataAuto((String) clientWbo.getAttribute("id"), callType, callStatus, session, "issue", persistentUser);
                if (issueId != null && !issueId.equals("")) {
                    WebBusinessObject issueWbo = issueMgr.getOnSingleKey(issueId);
                    request.setAttribute("issueId", issueId);
                    request.setAttribute("businessId", issueWbo.getAttribute("businessID"));
                }
            }
        } catch (NoUserInSessionException ex) {
            logger.error(ex);
        } catch (SQLException ex) {
            logger.error(ex);
        }

        if (!securityUser.getDefaultNewClientDistribution().equals("-1") && issueId != null) {
            try {
                freeEmployeeId = loads.getFreeEmployee(securityUser.getDefaultNewClientDistribution(), false);
                // try to create mail box
                if (freeEmployeeId != null) {
                    clientComplaintsMgr.createMailInBox(freeEmployeeId, issueId, "2", null, comment, subject, notes, persistentUser);
                }

                // try store prodcut for this client
                saveProduct(clientId, request);
            } catch (NoUserInSessionException ex) {
                logger.error(ex);
            } catch (SQLException ex) {
                logger.error(ex);
            } catch (Exception ex) {
                logger.error(ex);
            }
        }
    }

    public void autoPilot(List<String> clientIds, HttpSession session, WebBusinessObject persistentUser) {
        for (String clientId : clientIds) {
            autoPilot(clientId, null, session, persistentUser, false, null);
        }
    }

    public void autoPilot(String clientId, String freeEmployeeId, HttpSession session, WebBusinessObject persistentUser, boolean loggedOnly, String requestType) {
        SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");
        ClientComplaintsMgr clientComplaintsMgr = ClientComplaintsMgr.getInstance();
        EmployeesLoadsGroupSummaryMgr loads = EmployeesLoadsGroupSummaryMgr.getInstance();
        IssueMgr issueMgr = IssueMgr.getInstance();
        ClientMgr clientMgr = ClientMgr.getInstance();

        String issueId = null;
        String comment = "عميل جديد";
        String subject = "عميل جديد";
        String notes = "عميل جديد";
        if (requestType != null) {
            comment = requestType;
            subject = requestType;
            notes = requestType;
        }

        //Begin Automatically generate Record Number
        WebBusinessObject clientWbo = clientMgr.getOnSingleKey(clientId);
        try {
            if (securityUser != null && securityUser.getCallcenterMode() != null && !securityUser.getCallcenterMode().equals("1")) {
                String callStatus = null;
                String callType = null;
                if (securityUser.getCallcenterMode().equals("2")) {
                    callStatus = "incoming";
                    callType = "call";
                } else if (securityUser.getCallcenterMode().equals("3")) {
                    callStatus = "out_call";
                    callType = "call";
                } else if (securityUser.getCallcenterMode().equals("4")) {
                    callStatus = "incoming";
                    callType = "meeting";
                } else if (securityUser.getCallcenterMode().equals("5")) {
                    callStatus = "out_call";
                    callType = "meeting";
                } else if (securityUser.getCallcenterMode().equals("6")) {
                    callStatus = "incoming";
                    callType = "internet";
                }

                issueId = issueMgr.saveCallDataAuto((String) clientWbo.getAttribute("id"), callType, callStatus, session, "issue", persistentUser);
            }
        } catch (NoUserInSessionException ex) {
            logger.error(ex);
        } catch (SQLException ex) {
            logger.error(ex);
        }

        if (!securityUser.getDefaultNewClientDistribution().equals("-1") && issueId != null && freeEmployeeId == null) {
            try {
                freeEmployeeId = loads.getFreeEmployee(securityUser.getDefaultNewClientDistribution(), loggedOnly);
            } catch (Exception ex) {
                logger.error(ex);
            }
        }
        
        try {
            // try to create mail box
            if (freeEmployeeId != null) {
                clientComplaintsMgr.createMailInBox(freeEmployeeId, issueId, "2", null, comment, subject, notes, persistentUser);
            }
            // try store prodcut for this client
            saveProduct(securityUser.getUserId(), clientId, securityUser);
        } catch (NoUserInSessionException ex) {
            logger.error(ex);
        } catch (SQLException ex) {
            logger.error(ex);
        } catch (Exception ex) {
            logger.error(ex);
        }
    }

    public boolean saveProduct(String clientId, HttpServletRequest request) throws Exception {
        ClientProductMgr clientProductMgr = ClientProductMgr.getInstance();
        ProjectMgr projectMgr = ProjectMgr.getInstance();
        WebBusinessObject wbo;
        boolean isSaved = false;
        SecurityUser securityUser = (SecurityUser) request.getSession().getAttribute("securityUser");
        String userId = securityUser.getUserId();

        /*Vector products = projectMgr.getOnArbitraryKey("PRODUCTS", "key3");
        WebBusinessObject wbo2 = (WebBusinessObject) products.get(0);
        Vector mainProducts = projectMgr.getOnArbitraryKey((String) wbo2.getAttribute("projectID"), "key2");*/

        Vector mainProducts = projectMgr.getOnArbitraryKey("44", "key4");
        
        WebBusinessObject product;
        for (int i = 0; i < mainProducts.size(); i++) {
            String productChecked = request.getParameter("productChecked" + i);
            if (productChecked != null && productChecked.equals("on")) {
                String productId = request.getParameter("mainProductId" + i);
                product = projectMgr.getOnSingleKey(productId);
                if (product != null) {
                    String roomsCount = request.getParameter("roomsCount" + i);
                    String paymentType = request.getParameter("paymentType" + i);
                    String width = request.getParameter("width" + i);

                    wbo = new WebBusinessObject();
                    wbo.setAttribute("productId", productId);

                    wbo.setAttribute("productCategoryId", productId);
                    wbo.setAttribute("productName", "تصنيف عام");
                    wbo.setAttribute("productCategoryName", (String) product.getAttribute("projectName"));

                    wbo.setAttribute("budget", width);
                    wbo.setAttribute("period", roomsCount);
                    wbo.setAttribute("paymentSystem", paymentType);
                    wbo.setAttribute("notes", "UL");

                    // create client product
                    isSaved = clientProductMgr.saveImplicitClientQuery(clientId, userId, wbo);
                }
            }
        }
        if (!isSaved) {
            return saveProduct(userId, clientId, securityUser);
        }
        return false;
    }

    public boolean saveProduct(String userId, String clientId, SecurityUser security) throws Exception {
        ProjectMgr projectMgr = ProjectMgr.getInstance();
        String productId, projectName;
        productId = security.getDefaultProduct();
        projectName = projectMgr.getByKeyColumnValue(productId, "key1");
        if (productId == null && projectName == null) {
            WebBusinessObject project = projectMgr.getArbitraryProduct();
            if (project != null) {
                productId = (String) project.getAttribute("projectID");
                projectName = (String) project.getAttribute("projectName");
            }
        }
        if (productId != null && projectName != null) {
            //return saveProduct(userId, clientId, productId, projectName, "5", "نقدى", "100");
            return true;
        }
        return false;
    }

    public boolean saveProduct(String userId, String clientId, String productId, String projectName) throws Exception {
        return saveProduct(userId, clientId, productId, projectName, "5", "نقدى", "100");
    }

    public boolean saveProduct(String userId, String clientId, String productId, String projectName, String roomsCount, String paymentType, String width) throws Exception {
        ClientProductMgr clientProductMgr = ClientProductMgr.getInstance();
        WebBusinessObject wbo = new WebBusinessObject();
        wbo.setAttribute("productId", productId);

        wbo.setAttribute("productCategoryId", productId);
        wbo.setAttribute("productName", "تصنيف عام");
        wbo.setAttribute("productCategoryName", projectName);

        wbo.setAttribute("budget", width);
        wbo.setAttribute("period", roomsCount);
        wbo.setAttribute("paymentSystem", paymentType);
        wbo.setAttribute("notes", "UL");

        // create client product
        return clientProductMgr.saveImplicitClientQuery(clientId, userId, wbo);
    }
}
