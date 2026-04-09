package com.silkworm.common;

import com.crm.common.CRMConstants;
import java.util.ArrayList;
import java.util.List;
import com.silkworm.business_objects.*;
import com.silkworm.db_access.GrantsMgr;
import com.tracker.db_access.CampaignMgr;
import com.tracker.db_access.ProjectMgr;
import java.util.HashMap;
import java.util.Map;
import java.util.Vector;

public class SecurityUser {

    private static final String DEFUALT_AUTO_PILOT_MODE_VALUE = "1412756961849";
    private static final String DEFUALT_CALL_CENTER_MODE_VALUE = "2";
    private final GrantsMgr grantsMgr = GrantsMgr.getInstance();
    private Map<String, String> selectedTab = new HashMap<String, String>();
    private Map<String, String> withinIntervals = new HashMap<String, String>();
    private ArrayList<WebBusinessObject> clientMenuBtn = new ArrayList();
    private ArrayList<WebBusinessObject> complaintMenuBtn = new ArrayList();
    private Vector<WebBusinessObject> userGroup = new Vector();
    private List userAction = new ArrayList();
    private List userStores = new ArrayList();
    private List userProjects = new ArrayList();
    private WebBusinessObject grantsWbo = new WebBusinessObject();
    private WebBusinessObject grantsUserWbo = new WebBusinessObject();
    private String userId;
    private String userName;
    private String encryptedUserName;
    private String userPassword;
    private String encryptedUserPassword;
    private String userMail;
    private String userGroupId;
    private String userGroupName;
    private String userTradeId;
    private String userTradeName;
    private String siteId;
    private String siteName;
    private String superUser;
    private String searchBy;
    private String defaultPage;
    private String fullName;
    private String loginDate;
    private String defaultCampaign;
    private String defaultCampaignName;
    private String defaultProduct;
    private String callcenterMode;
    private String callcenterModeName;
    private String defaultNewClientDistribution;
    private String defaultNewClientDistributionName;
    private boolean canRunCampaignMode = true;
    private boolean canRunAutoPilotMode = false;
    private String userDivision ;
    private boolean canChangeHeadBar = false;
    private String lastLogin = "---";
    private String distributionGroup;
    private String menuString;
    private String menuEnString;
    private String managerName;
    private String departmentName;
    private String compayId;
    private String compayName;
    private String personalDistribution;
    private String personalDistributionType;

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getUserPassword() {
        return userPassword;
    }

    public void setUserPassword(String userPassword) {
        this.userPassword = userPassword;
    }

    public String getUserMail() {
        return userMail;
    }

    public void setUserMail(String userMail) {
        this.userMail = userMail;
    }

    public String getUserGroupId() {
        return userGroupId;
    }

    public void setUserGroupId(String userGroupId) {
        this.userGroupId = userGroupId;
    }

    public String getUserGroupName() {
        return userGroupName;
    }

    public void setUserGroupName(String userGroupName) {
        this.userGroupName = userGroupName;
    }

    public String getUserTradeId() {
        return userTradeId;
    }

    public void setUserTradeId(String userTradeId) {
        this.userTradeId = userTradeId;
    }

    public String getUserTradeName() {
        return userTradeName;
    }

    public void setUserTradeName(String userTradeName) {
        this.userTradeName = userTradeName;
    }

    public String getSiteId() {
        return siteId;
    }

    public void setSiteId(String siteId) {
        this.siteId = siteId;
        this.siteName = ProjectMgr.getInstance().getByKeyColumnValue(this.siteId, "key1");
        if (this.siteName == null) {
            this.siteName = "***";
        }
    }

    public String getSiteName() {
        return siteName;
    }

    public void setSiteName(String siteName) {
        this.siteName = siteName;
    }

    public List getUserAction() {
        return userAction;
    }

    public void setUserAction(List userAction) {
        this.userAction = userAction;
    }

    public List getUserStores() {
        return userStores;
    }

    public void setUserStores(List userStores) {
        this.userStores = userStores;
    }

    public List getUserProjects() {
        return userProjects;
    }

    public void setUserProjects(List userProjects) {
        this.userProjects = userProjects;
        for (WebBusinessObject project : ((List<WebBusinessObject>) userProjects)) {
            if (project.getAttribute("isDefault") != null && project.getAttribute("isDefault").toString().equalsIgnoreCase("1")) {
                siteId = (String) project.getAttribute("projectID");
                siteName = (String) project.getAttribute("projectName");
            }
        }
    }

    public String getSearchBy() {
        return searchBy;
    }

    public void setCompanyId(String companyID) {
        this.compayId = companyID;
    }
    
    public String getCompanyId() {
        return compayId;
    }

    public void setCompanyName(String companyName) {
        this.compayName = companyName;
    }
    
    public String getCompanyName() {
        return compayName;
    }

    public void setSearchBy(String searchBy) {
        this.searchBy = searchBy;
    }

    public void setSuperUser(String superUser) {
        this.superUser = superUser;
    }

    public boolean isSuperUser() {
        return (this.superUser != null && this.superUser.equals("1"));
    }

    public Vector<WebBusinessObject> getUserGroup() {
        return userGroup;
    }

    public void setUserGroup(Vector<WebBusinessObject> userGroup) {
        this.userGroup = userGroup;
    }

    public boolean verifyDelete() {
        boolean action = false;
        for (int i = 0; i < getUserAction().size(); i++) {
            grantsUserWbo = (WebBusinessObject) getUserAction().get(i);
            grantsWbo = (WebBusinessObject) grantsMgr.getOnSingleKey(grantsUserWbo.getAttribute("grantId").toString());
            if (grantsWbo.getAttribute("grantName").equals("delete")) {
                action = true;
                break;
            }
        }

        return action;
    }

    public boolean verifyView() {
        boolean action = false;
        for (int i = 0; i < getUserAction().size(); i++) {
            grantsUserWbo = (WebBusinessObject) getUserAction().get(i);
            grantsWbo = (WebBusinessObject) grantsMgr.getOnSingleKey(grantsUserWbo.getAttribute("grantId").toString());
            if (grantsWbo.getAttribute("grantName").equals("view")) {
                action = true;
                break;
            }
        }
        return action;
    }

    public boolean verifyCreate() {
        boolean action = false;
        for (int i = 0; i < getUserAction().size(); i++) {
            grantsUserWbo = (WebBusinessObject) getUserAction().get(i);
            grantsWbo = (WebBusinessObject) grantsMgr.getOnSingleKey(grantsUserWbo.getAttribute("grantId").toString());
            if (grantsWbo.getAttribute("grantName").equals("create")) {
                action = true;
                break;
            }
        }
        return action;
    }

    public String[] getBranchesAsArray() {
        String[] list = {""};
        WebBusinessObject wbo;
        try {
            list = new String[this.userProjects.size()];

            for (int i = 0; i < this.userProjects.size(); i++) {
                wbo = (WebBusinessObject) this.userProjects.get(i);

                list[i] = (String) wbo.getAttribute("projectID");
            }
        } catch (Exception ex) {
        }

        return list;
    }

    public void setCustomizationValues(Map<CustomizationPanelElement, String> configuration, WebBusinessObject loggedUser) {
        setDefaultCampaign(configuration.get(CustomizationPanelElement.CAMPAIGN_ELEMENT));
        setCallcenterMode(configuration.get(CustomizationPanelElement.CHANEL_DIRECTION_ELEMENT));
        setDefaultProduct(configuration.get(CustomizationPanelElement.PRODUCT_ELEMENT));
        setSiteId(configuration.get(CustomizationPanelElement.DEFAULT_BRANCH_ELEMENT));
        setDefaultNewClientDistribution(configuration.get(CustomizationPanelElement.DEFAULT_NEW_CLIENT_DISTRIBUTION_ELEMENT));
        setCanChangeHeadBar(configuration.get(CustomizationPanelElement.CAN_CHANGE_HEAD_BAR_ELEMENT));
        setCanRunAutoPilotMode("1".equalsIgnoreCase(configuration.get(CustomizationPanelElement.RUN_ON_AUTO_PILOT_ELEMENT)));
        setDistributionGroup(configuration.get(CustomizationPanelElement.DISTRIBUTION_GROUP_ELEMENT));
        setPersonalDistribution(configuration.get(CustomizationPanelElement.PERSONAL_DISTRIBUTION_ELEMENT));
        setPersonalDistributionType(configuration.get(CustomizationPanelElement.PERSONAL_DISTRIBUTION_TYPE_ELEMENT));

        GroupMgr groupMgr = GroupMgr.getInstance();
        String groupId = configuration.get(CustomizationPanelElement.DEFAULT_DESKTOP_ELEMENT);
        WebBusinessObject group = groupMgr.getOnSingleKey(groupId);
        if (groupId == null) {
            group = groupMgr.getDefaultGroup(userId);
        }
        if (group != null) {
            groupId = (String) group.getAttribute("groupID");
            setUserGroupId(groupId);
            setUserGroupName((String) group.getAttribute("groupName"));
            setDefaultPage((String) group.getAttribute("defaultPage"));
            loggedUser.setAttribute("groupID", groupId);
            loggedUser.setAttribute("groupName", (String) group.getAttribute("groupName"));
        }
    }

    public String getEncryptedUserName() {
        return encryptedUserName;
    }

    public void setEncryptedUserName(String encryptedUserName) {
        this.encryptedUserName = encryptedUserName;
    }

    public String getEncryptedUserPassword() {
        return encryptedUserPassword;
    }

    public void setEncryptedUserPassword(String encryptedUserPassword) {
        this.encryptedUserPassword = encryptedUserPassword;
    }

    public String getDefaultPage() {
        return defaultPage;
    }

    public void setDefaultPage(String defaultPage) {
        this.defaultPage = defaultPage;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getFullName() {
        return fullName;
    }

    public ArrayList<WebBusinessObject> getClientMenuBtn() {
        return clientMenuBtn;
    }

    public void setClientMenuBtn(ArrayList<WebBusinessObject> clientMenuBtn) {
        this.clientMenuBtn = clientMenuBtn;
    }

    public ArrayList<WebBusinessObject> getComplaintMenuBtn() {
        return complaintMenuBtn;
    }

    public void setComplaintMenuBtn(ArrayList<WebBusinessObject> complaintMenuBtn) {
        this.complaintMenuBtn = complaintMenuBtn;
    }

    public String getLoginDate() {
        return loginDate;
    }

    public void setLoginDate(String loginDate) {
        this.loginDate = loginDate;
    }

    public String getDefaultCampaign() {
        return defaultCampaign;
    }

    public void setDefaultCampaign(String defaultCampaign) {
        this.defaultCampaign = defaultCampaign;
        this.defaultCampaignName = CampaignMgr.getInstance().getByKeyColumnValue(defaultCampaign, "key5");
        if (this.getDefaultCampaignName() == null) {
            this.defaultCampaignName = "***";
        }
    }

    public boolean isCanRunCampaignMode() {
        return canRunCampaignMode;
    }

    public void setCanRunCampaignMode(boolean canRunCampaignMode) {
        this.canRunCampaignMode = canRunCampaignMode;
    }

    public String getCallcenterMode() {
        return callcenterMode;
    }

    public void setCallcenterMode(String callcenterMode) {
        this.callcenterMode = (callcenterMode != null) ? callcenterMode : DEFUALT_CALL_CENTER_MODE_VALUE;
        this.callcenterModeName = CRMConstants.parseCallCenter(this.callcenterMode);
    }

    public Map<String, String> getSelectedTab() {
        return selectedTab;
    }

    public void setSelectedTab(Map<String, String> selectedTab) {
        this.selectedTab = selectedTab;
    }

    public Map<String, String> getWithinIntervals() {
        return withinIntervals;
    }

    public void setWithinInterval(Map<String, String> withinIntervals) {
        this.withinIntervals = withinIntervals;
    }

    public String getDefaultNewClientDistribution() {
        return defaultNewClientDistribution;
    }

    public void setDefaultNewClientDistribution(String defaultNewClientDistribution) {
        this.defaultNewClientDistribution = (defaultNewClientDistribution != null) ? defaultNewClientDistribution : DEFUALT_AUTO_PILOT_MODE_VALUE;
        this.defaultNewClientDistributionName = GroupMgr.getInstance().getByKeyColumnValue(this.defaultNewClientDistribution, "keyname");
        if (this.getDefaultNewClientDistributionName() == null) {
            this.defaultNewClientDistributionName = "***";
        }
    }

    public String getUserDivision() {
        return userDivision;
    }

    public void setUserDivision(String userDivision) {
        this.userDivision = userDivision;
    }

    public String getDefaultProduct() {
        return defaultProduct;
    }

    public void setDefaultProduct(String defaultProduct) {
        this.defaultProduct = defaultProduct;
    }

    public boolean isCanChangeHeadBar() {
        return canChangeHeadBar;
    }

    public void setCanChangeHeadBar(String canChangeHeadBar) {
        this.canChangeHeadBar = CRMConstants.FREEZE_HEAD_BAR_YES.equalsIgnoreCase(canChangeHeadBar);
    }

    public String getDefaultCampaignName() {
        return defaultCampaignName;
    }

    public String getCallcenterModeName() {
        return callcenterModeName;
    }

    public String getDefaultNewClientDistributionName() {
        return defaultNewClientDistributionName;
    }

    public boolean isCanRunAutoPilotMode() {
        return canRunAutoPilotMode;
    }

    public void setCanRunAutoPilotMode(boolean canRunAutoPilotMode) {
        this.canRunAutoPilotMode = canRunAutoPilotMode;
    }

    public String getLastLogin() {
        return lastLogin;
    }

    public void setLastLogin(String lastLogin) {
        this.lastLogin = lastLogin;
    }
    
    public String getDistributionGroup() {
        return distributionGroup;
    }

    public void setDistributionGroup(String distributionGroup) {
        this.distributionGroup = (distributionGroup != null) ? distributionGroup : "";
    }
    
    public void setMenuString(String menuString) {
        this.menuString = menuString;
    }
    
    public String getMenuString() {
        return this.menuString;
    }
    
    public String getMenuEnString() {
        return menuEnString;
    }

    public void setMenuEnString(String menuEnString) {
        this.menuEnString = menuEnString;
    }

    public String getManagerName() {
        return managerName;
    }

    public void setManagerName(String managerName) {
        this.managerName = managerName;
    }

    public String getDepartmentName() {
        return departmentName;
    }

    public void setDepartmentName(String departmentName) {
        this.departmentName = departmentName;
    }

    public String getPersonalDistribution() {
        return personalDistribution;
    }

    public void setPersonalDistribution(String personalDistribution) {
        this.personalDistribution = personalDistribution;
    }

    public String getPersonalDistributionType() {
        return personalDistributionType;
    }

    public void setPersonalDistributionType(String personalDistributionType) {
        this.personalDistributionType = personalDistributionType;
    }

}
