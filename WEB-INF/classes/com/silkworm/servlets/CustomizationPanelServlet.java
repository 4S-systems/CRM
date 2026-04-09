/*
 * HelpServlet.java
 *
 * Created on April 30, 2004, 7:58 AM
 */
package com.silkworm.servlets;

import com.maintenance.db_access.UserProjectsMgr;
import com.silkworm.business_objects.WebBusinessObject;
import com.silkworm.common.CustomizationPanelElement;
import com.silkworm.common.GroupMgr;
import com.silkworm.common.SecurityUser;
import com.silkworm.common.UserGroupMgr;
import com.silkworm.db_access.CustomizationPanelMgr;
import static com.silkworm.servlets.swBaseServlet.logger;
import com.tracker.db_access.CampaignMgr;
import com.tracker.db_access.ProjectMgr;
import java.io.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import javax.servlet.*;
import javax.servlet.http.*;
import com.maintenance.db_access.UserCompaniesMgr;
import java.util.logging.Level;
import java.util.logging.Logger;
/**
 *
 * @author walid
 * @version
 */
public class CustomizationPanelServlet extends swBaseServlet {

    private CustomizationPanelMgr customizationMgr;
    private CampaignMgr campaignMgr;
    private ProjectMgr projectMgr;
    private UserGroupMgr userGroupMgr;
    private GroupMgr groupMgr;
    private UserCompaniesMgr userCompanyMgr;
    private UserProjectsMgr userProjectsMgr;
    private Map<CustomizationPanelElement, String> map;
    private List<WebBusinessObject> tools;
    private List<WebBusinessObject> allgroups;
    private List<WebBusinessObject> groups;
    private List<WebBusinessObject> branchs;
    private List<WebBusinessObject> products;
    private WebBusinessObject wbo;
    private String userId;
    private String seletedCampaign;
    private String seletedDefaultNewClientDistribution;
    private String seletedRunOnAutoPilot;
    private String seletedDefaultBranch;
    private String seletedDefaultDesktop;
    private String seletedProduct;
    private String seletedChanelDirection;
    private String seletedCanChangeHeadBar;
    private String selectedDistributionGroup;

    /**
     * Destroys the servlet.
     */
    @Override
    public void destroy() {
    }

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws javax.servlet.ServletException
     * @throws java.io.IOException
     */
    @Override
    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        super.processRequest(request, response);
        HttpSession session = request.getSession();
        WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
        String loggegUserId = (String) loggedUser.getAttribute("userId");
        SecurityUser securityUser = (SecurityUser) request.getSession().getAttribute("securityUser");

        this.customizationMgr = CustomizationPanelMgr.getInstance();
        this.campaignMgr = CampaignMgr.getInstance();
        this.projectMgr = ProjectMgr.getInstance();
        this.userGroupMgr = UserGroupMgr.getInstance();
        this.groupMgr = GroupMgr.getInstance();
        this.userProjectsMgr = UserProjectsMgr.getInstance();
        this.tools = new ArrayList<WebBusinessObject>();
        this.allgroups = new ArrayList<WebBusinessObject>();
        this.groups = new ArrayList<WebBusinessObject>();
        this.branchs = new ArrayList<WebBusinessObject>();
        this.products = new ArrayList<WebBusinessObject>();

        operation = getOpCode((String) request.getParameter("op"));
        switch (operation) {
            case 1:
                servedPage = "/docs/customization/customization_panel_form.jsp";
                userId = request.getParameter("userId");

                map = customizationMgr.getCustomizationUser(userId);

                // to get branchs
                branchs = userProjectsMgr.getByUserId(userId);

                // to get groups
                allgroups = groupMgr.getCashedTable();
                groups = userGroupMgr.getByUserId(userId);

                try {
                    // to get tools
                    tools = new ArrayList<WebBusinessObject>(campaignMgr.getOnArbitraryKeyOracle("16", "key4"));
                    tools.addAll(campaignMgr.getOnArbitraryKeyOracle("20", "key4"));
                } catch (Exception ex) {
                    logger.error(ex);
                }

                // to get products
                try {
                    userCompanyMgr = UserCompaniesMgr.getInstance();
                    WebBusinessObject userCompanyWbo = userCompanyMgr.getOnSingleKey("key1",userId);
                    
                    if(userCompanyWbo != null){
                    products = projectMgr.getOnArbitraryKey(userCompanyWbo.getAttribute("companyID").toString(), "key2");
                    wbo = (WebBusinessObject) products.get(0);
                    products = projectMgr.getOnArbitraryKey((String) wbo.getAttribute("mainProjId"), "key2");
                    } else {
                        products = projectMgr.getOnArbitraryKey("44", "key6");
                    }
                    //products = projectMgr.getOnArbitraryKey("PRODUCTS", "key3");
//                    wbo = (WebBusinessObject) products.get(0);
//                    products = projectMgr.getOnArbitraryKey((String) wbo.getAttribute("mainProjId"), "key2");
                } catch (Exception ex) {
                    logger.error(ex);
                }

                request.setAttribute("page", servedPage);
                request.setAttribute("map", map);
                request.setAttribute("tools", tools);
                request.setAttribute("allgroups", allgroups);
                request.setAttribute("groups", groups);
                request.setAttribute("branchs", branchs);
                request.setAttribute("products", products);
                try {
                    request.setAttribute("requestTypes", new ArrayList<>(projectMgr.getOnArbitraryKeyOracle("RQ-TYPE", "key6")));
                } catch (Exception ex) {
                    request.setAttribute("requestTypes", new ArrayList<>());
                }
                this.forwardToServedPage(request, response);
                break;

            case 2:
                userId = request.getParameter("userId");
                seletedCampaign = request.getParameter("seletedCampaign");
                seletedDefaultNewClientDistribution = request.getParameter("seletedDefaultNewClientDistribution");
                seletedDefaultDesktop = request.getParameter("seletedDefaultDesktop");
                seletedDefaultBranch = request.getParameter("seletedDefaultBranch");
                seletedProduct = request.getParameter("seletedProduct");
                seletedChanelDirection = request.getParameter("seletedChanelDirection");
                seletedCanChangeHeadBar = request.getParameter("seletedCanChangeHeadBar");
                seletedRunOnAutoPilot = request.getParameter("seletedRunOnAutoPilot");
                selectedDistributionGroup = request.getParameter("selectedDistributionGroup");
                String selectedPersonalDistribution = request.getParameter("selectedPersonalDistribution");
                String selectedPersonalDistributionType = request.getParameter("selectedPersonalDistributionType");

                String[] names = new String[]{CustomizationPanelElement.CAMPAIGN_ELEMENT.getName(),
                    CustomizationPanelElement.DEFAULT_NEW_CLIENT_DISTRIBUTION_ELEMENT.getName(),
                    CustomizationPanelElement.RUN_ON_AUTO_PILOT_ELEMENT.getName(),
                    CustomizationPanelElement.DEFAULT_BRANCH_ELEMENT.getName(),
                    CustomizationPanelElement.DEFAULT_DESKTOP_ELEMENT.getName(),
                    CustomizationPanelElement.PRODUCT_ELEMENT.getName(),
                    CustomizationPanelElement.CHANEL_DIRECTION_ELEMENT.getName(),
                    CustomizationPanelElement.CAN_CHANGE_HEAD_BAR_ELEMENT.getName(),
                    CustomizationPanelElement.DISTRIBUTION_GROUP_ELEMENT.getName(),
                    CustomizationPanelElement.PERSONAL_DISTRIBUTION_ELEMENT.getName(),
                    CustomizationPanelElement.PERSONAL_DISTRIBUTION_TYPE_ELEMENT.getName()};
                String[] values = new String[]{seletedCampaign, seletedDefaultNewClientDistribution, seletedRunOnAutoPilot,
                    seletedDefaultBranch, seletedDefaultDesktop, seletedProduct, seletedChanelDirection, seletedCanChangeHeadBar,
                    selectedDistributionGroup, selectedPersonalDistribution, selectedPersonalDistributionType};

                if (customizationMgr.saveObject(userId, names, values, loggegUserId)) {
                    // change settings for current user 
                    if (loggegUserId.equalsIgnoreCase(userId)) {
                        Map<CustomizationPanelElement, String> customization = customizationMgr.getCustomizationUser(loggegUserId);
                        securityUser.setCustomizationValues(customization, loggedUser);
                    }
                    request.setAttribute("status", "ok");
                } else {
                    request.setAttribute("status", "no");
                }
                this.forward("/CustomizationPanelServlet?op=customizationPanelForm", request, response);
                break;

            default:
                break;
        }
    }

    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws javax.servlet.ServletException
     * @throws java.io.IOException
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws javax.servlet.ServletException
     * @throws java.io.IOException
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return
     */
    @Override
    public String getServletInfo() {
        return "Help Servlet";
    }

    @Override
    protected int getOpCode(String opName) {
        if (opName.equalsIgnoreCase("customizationPanelForm")) {
            return 1;
        }
        if (opName.equalsIgnoreCase("customizationPanelStore")) {
            return 2;
        }

        return 0;
    }
}
